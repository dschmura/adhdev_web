# Preview all emails at http://localhost:3000/rails/mailers/team_invitations_mailer
class TeamInvitationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/team_invitations_mailer/invite
  def invite
    team = Team.new(name: "Example Team")
    team_invitation = TeamInvitation.new(id: 1, token: "fake", team: team, name: "Test User", email: "test@example.com", invited_by: User.first)
    TeamInvitationsMailer.with(team_invitation: team_invitation).invite
  end

end
