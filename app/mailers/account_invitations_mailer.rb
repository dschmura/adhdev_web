class AccountInvitationsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.account_invitations_mailer.invite.subject
  #
  def invite
    @account_invitation = params[:account_invitation]
    @account = @account_invitation.account
    @invited_by = @account_invitation.invited_by

    name = @account_invitation.name
    email = @account_invitation.email

    mail(
      to: "#{name} <#{email}>",
      from: "#{@invited_by.name} <#{Jumpstart.config.support_email}>",
      subject: t(".subject", inviter: @invited_by.name, account: @account.name)
    )
  end
end
