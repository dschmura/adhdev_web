class TeamInvitationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.team_invitations_mailer.invite.subject
  #
  def invite
    @team_invitation = params[:team_invitation]
    @team = @team_invitation.team
    @invited_by = @team_invitation.invited_by

    name = @team_invitation.name
    email = @team_invitation.email

    mail(
      to: "#{name} <#{email}>",
      from: "#{@invited_by.name} <#{Jumpstart.config.support_email}>",
      subject: I18n.t("team_invitations_mailer.invite.subject", inviter: @invited_by.name, team: @team.name)
    )
  end
end
