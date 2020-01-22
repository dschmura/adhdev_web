class TeamInvitationsController < ApplicationController
  before_action :set_team_invitation
  before_action :authenticate_user_with_sign_up!

  def show
    @team = @team_invitation.team
    @invited_by = @team_invitation.invited_by
  end

  def update
    if @team_invitation.accept!(current_user)
      redirect_to teams_path
    else
      message = @team_invitation.errors.full_messages.first || "Something went wrong"
      redirect_to team_invitation_path(@team_invitation), alert: message
    end
  end

  def destroy
    @team_invitation.reject!
    redirect_to root_path
  end

  private

    def set_team_invitation
      @team_invitation = TeamInvitation.find_by!(token: params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path, alert: "Whoops, we weren't able to find this invitation. Check with your team admin for a new invitation."
    end
end
