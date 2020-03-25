# == Schema Information
#
# Table name: account_users
#
#  id         :bigint(8)        not null, primary key
#  roles      :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id    :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_account_users_on_account_id  (account_id)
#  index_account_users_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#

require "test_helper"

class AccountUserTest < ActiveSupport::TestCase
  test "converts roles to booleans" do
    member = AccountUser.new admin: "1"
    assert_equal true, member.admin
  end

  test "can be assigned a role" do
    member = AccountUser.new admin: true
    assert_equal true, member.admin
    assert_equal true, member.admin?
  end

  test "role can be false" do
    member = AccountUser.new admin: false
    assert_equal false, member.admin
    assert_equal false, member.admin?
  end

  test "keeps track of active roles" do
    member = AccountUser.new admin: true
    assert_equal [:admin], member.active_roles
  end

  test "has no active roles" do
    member = AccountUser.new admin: false
    assert_empty member.active_roles
  end
end
