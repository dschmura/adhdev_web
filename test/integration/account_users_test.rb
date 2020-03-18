require "test_helper"

class Jumpstart::AccountUsersTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:company)
    @admin = users(:one)
    @regular_user = users(:two)
  end

  class AdminUsers < Jumpstart::AccountUsersTest
    setup do
      sign_in @admin
    end

    test "can view account users" do
      get account_path(@account)
      assert_select "h1", @account.name
      assert_select "a", text: "Edit Account", count: 1
      assert_select "a", text: "Edit", count: @account.account_users.count + @account.account_invitations.count
      assert_select "a", text: "Invite A User", count: 1
    end

    test "can view new account user form" do
      get new_account_account_user_path(@account)
      assert_select "button", "Send invitation"
    end

    test "can add account users" do
      name, email = "Account Member", "new-user@example.com"
      assert_difference "@account.account_users.count" do
        post account_account_users_path(@account), params: {name: name, email: email, account_user: {admin: "0"}}
      end
      assert_response :redirect
      account_user = @account.account_users.find_by(user: User.find_by(email: email))
      assert account_user
      assert_not account_user.admin?
    end

    test "can add account users with roles" do
      name, email = "Account Member", "new-user@example.com"
      assert_difference "@account.account_users.count" do
        post account_account_users_path(@account), params: {name: name, email: email, account_user: {admin: "1"}}
      end
      assert_response :redirect
      account_user = @account.account_users.find_by(user: User.find_by(email: email))
      assert account_user
      assert account_user.admin?
    end

    test "can edit account user" do
      account_user = account_users(:company_regular_user)
      get edit_account_account_user_path(@account, account_user)
      assert_select "button", "Update Account user"
    end

    test "can update account user" do
      account_user = account_users(:company_regular_user)
      put account_account_user_path(@account, account_user), params: {account_user: {admin: "1"}}
      assert_response :redirect
      assert account_user.reload.admin?
    end

    test "can delete account users" do
      user = users(:two)
      user = @account.account_users.find_by(user: user)
      assert_difference "@account.account_users.count", -1 do
        delete account_account_user_path(@account, user.id)
      end
      assert_response :redirect
    end
  end

  class RegularUsers < Jumpstart::AccountUsersTest
    setup do
      sign_in @regular_user
    end

    test "can view account users but not edit" do
      get account_path(@account)
      assert_select "h1", @account.name

      assert_select "a", text: "Edit Account", count: 0
      assert_select "a", text: "Edit", count: 0
      assert_select "a", text: "Invite A Account Member", count: 0
    end

    test "can view new account user form" do
      get new_account_account_user_path(@account)
      assert_redirected_to account_path(@account)
    end

    test "Regular user cannot view account user page" do
      get account_account_user_path(@account, @admin)
      assert_redirected_to account_path(@account)
    end

    test "Regular user cannot add account users" do
      name, email = "Account Member", "new-user@example.com"
      post account_account_users_path(@account), params: {name: name, email: email}
      assert_redirected_to account_path(@account)
    end

    test "Regular user cannot edit account users" do
      # Cannot edit themselves
      account_user = @account.account_users.find_by(user: @regular_user)
      get edit_account_account_user_path(@account, account_user)
      assert_redirected_to account_path(@account)

      # Cannot edit admin user
      account_user = @account.account_users.find_by(user: @admin)
      get edit_account_account_user_path(@account, account_user)
      assert_redirected_to account_path(@account)
    end

    test "Regular user cannot update account users" do
      # Cannot edit themselves
      account_user = @account.account_users.find_by(user: @regular_user)
      put account_account_user_path(@account, account_user), params: {admin: "1"}
      assert_redirected_to account_path(@account)

      # Cannot edit admin user
      account_user = @account.account_users.find_by(user: @admin)
      put account_account_user_path(@account, account_user), params: {admin: "0"}
      assert_redirected_to account_path(@account)
    end

    test "Regular user cannot delete account users" do
      user = users(:one)
      account_user = @account.account_users.find_by(user: user)
      delete account_account_user_path(@account, account_user.id)
      assert_redirected_to account_path(@account)
      assert_includes @account.account_users.pluck(:user_id), user.id
    end
  end
end
