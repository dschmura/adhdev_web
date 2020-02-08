require 'test_helper'

class CurrentHelperTest < ActionView::TestCase
  def current_user
    @current_user
  end

  setup do
    @current_user = users(:one)
    @current_account = nil
    @current_account_user = nil
    session[:account_id] = nil
  end

  test "current_account" do
    assert_not_nil current_account
  end

  test "uses account from session" do
    # The first account is the fallback, so we want to check that it uses the second account
    account = current_user.accounts.last
    session[:account_id] = account.id
    assert_equal account, current_account
  end

  test "creates a account if none exist" do
    @current_user = users(:noaccount)
    assert_empty current_user.accounts
    assert_not_nil current_account
  end

  test "current_account_user" do
    assert_not_nil current_account_user
  end

  test 'current_account_admin returns true for an admin' do
    @current_account_user = account_users(:two)
    assert current_account_admin?
  end

  test 'current_account_admin returns false for a non admin' do
    @current_account_user = account_users(:company_regular_user)
    assert_not current_account_admin?
  end

  test "current account member is from current account" do
    account_user = current_user.account_users.last
    session[:account_id] = account_user.account_id
    assert_equal account_user, current_account_user
  end

  test "current_roles" do
    @current_account = accounts(:company)
    assert_equal [:admin], current_roles
  end
end
