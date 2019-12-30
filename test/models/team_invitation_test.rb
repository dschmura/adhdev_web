require 'test_helper'

class TeamInvitationTest < ActiveSupport::TestCase
  setup do
    @team_invitation = team_invitations(:one)
  end

  test "accept" do
    user = users(:noteam)
    assert_difference "TeamMember.count" do
      team_member = @team_invitation.accept!(user)
      assert team_member.persisted?
      assert_equal user, team_member.user
    end

    assert_raises ActiveRecord::RecordNotFound do
      @team_invitation.reload
    end
  end

  test "reject" do
    assert_difference "TeamInvitation.count", -1 do
      @team_invitation.reject!
    end
  end
end
