require 'test_helper'

class TeamInvitationsMailerTest < ActionMailer::TestCase
  test "invite" do
    team_invitation = team_invitations(:one)
    mail = TeamInvitationsMailer.with(team_invitation: team_invitation).invite
    assert_equal "User One invited you to Company Team", mail.subject
    assert_equal [team_invitation.email], mail.to
    assert_equal [Jumpstart.config.support_email], mail.from
    assert_match "View invitation", mail.body.encoded
  end

end
