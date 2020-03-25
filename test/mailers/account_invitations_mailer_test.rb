require "test_helper"

class AccountInvitationsMailerTest < ActionMailer::TestCase
  test "invite" do
    account_invitation = account_invitations(:one)
    mail = AccountInvitationsMailer.with(account_invitation: account_invitation).invite
    assert_equal "User One invited you to Company", mail.subject
    assert_equal [account_invitation.email], mail.to
    assert_equal [Jumpstart.config.support_email], mail.from
    assert_match "View invitation", mail.body.encoded
  end
end
