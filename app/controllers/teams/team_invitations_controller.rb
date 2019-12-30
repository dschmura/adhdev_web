class Teams::TeamInvitationsController < ApplicationController
  before_action :set_team
  before_action :require_team_admin
  before_action :set_team_invitation, only: [:edit, :update, :destroy]

  def new
    @team_invitation = TeamInvitation.new
  end

  def create
    @team_invitation = TeamInvitation.new(invitation_params)
    if @team_invitation.save_and_send_invite
      redirect_to @team
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @team_invitation.update(invitation_params)
      redirect_to @team
    else
      render :edit
    end
  end


  def destroy
    @team_invitation.destroy
    redirect_to @team
  end

  private

    def set_team
      @team = current_user.teams.find(params[:team_id])
    end

    def set_team_invitation
      @team_invitation = @team.team_invitations.find_by!(token: params[:id])
    end

    def invitation_params
      params
        .require(:team_invitation)
        .permit(:name, :email, TeamMember::ROLES)
        .merge(team: @team, invited_by: current_user)
    end

    def require_team_admin
      team_member = @team.team_members.find_by(user: current_user)
      unless team_member && team_member.active_roles.include?(:admin)
        redirect_to @team, alert: "Only team admins are allowed to do that."
      end
    end
end
