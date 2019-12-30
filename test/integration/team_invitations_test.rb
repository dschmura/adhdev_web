require 'test_helper'

class Jumpstart::TeamInvitationsTest < ActionDispatch::IntegrationTest
  setup do
    @team_invitation = team_invitations(:one)
    @team = @team_invitation.team
    @inviter = @team.users.first
    @invited = users(:noteam)
  end

  test "cannot view invitation when logged out" do
    get team_invitation_path(@team_invitation)
    assert_redirected_to new_user_registration_path
    assert "Create an account to accept your invitation", flash[:alert]
  end

  test "can view invitation when logged in" do
    sign_in @invited
    get team_invitation_path(@team_invitation)
    assert_response :success
  end

  test "can decline invitation" do
    sign_in @invited
    assert_difference "TeamInvitation.count", -1 do
      delete team_invitation_path(@team_invitation)
    end
  end

  test "can accept invitation" do
    sign_in @invited
    assert_difference "TeamMember.count" do
      assert_difference "TeamInvitation.count", -1 do
        put team_invitation_path(@team_invitation)
      end
    end
  end

  test "fails to accept invitation if validation issues" do
    sign_in users(:one)
    put team_invitation_path(@team_invitation)
    assert_redirected_to team_invitation_path(@team_invitation)
  end
end
