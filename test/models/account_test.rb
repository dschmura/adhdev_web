require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "validates against reserved domains" do
    account = Account.new(domain: Jumpstart.config.domain)

    assert_not account.valid?
    assert_not_empty account.errors[:domain]
  end

  test "validates against reserved subdomains" do
    subdomain = Account::RESERVED_SUBDOMAINS.first
    account = Account.new(subdomain: subdomain)

    assert_not account.valid?
    assert_not_empty account.errors[:subdomain]
  end
end
