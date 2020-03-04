require 'test_helper'

class Jumpstart::AccountInvitationsTest < ActionDispatch::IntegrationTest
  setup do
    @account_invitation = account_invitations(:one)
    @account = @account_invitation.account
    @inviter = @account.users.first
    @invited = users(:invited)
  end

  test "cannot view invitation when logged out" do
    get account_invitation_path(@account_invitation)
    assert_redirected_to new_user_registration_path
    assert "Create an account to accept your invitation", flash[:alert]
  end

  test "can view invitation when logged in" do
    sign_in @invited
    get account_invitation_path(@account_invitation)
    assert_response :success
  end

  test "can decline invitation" do
    sign_in @invited
    assert_difference "AccountInvitation.count", -1 do
      delete account_invitation_path(@account_invitation)
    end
  end

  test "can accept invitation" do
    sign_in @invited
    assert_difference "AccountUser.count" do
      assert_difference "AccountInvitation.count", -1 do
        put account_invitation_path(@account_invitation)
      end
    end
  end

  test "fails to accept invitation if validation issues" do
    sign_in users(:one)
    put account_invitation_path(@account_invitation)
    assert_redirected_to account_invitation_path(@account_invitation)
  end
end
