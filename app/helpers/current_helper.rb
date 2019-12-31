module CurrentHelper
  def current_team
    @current_team ||= current_user.teams.find(session[:team_id])
  rescue ActiveRecord::RecordNotFound
    @current_team ||= current_user.teams.first
    @current_team ||= current_user.create_personal_team
  end

  def current_team_member
    @current_team_member ||= current_team.team_members.find_by(user: current_user)
  end

  def current_roles
    current_team_member.active_roles
  end

  def current_team_admin?
    !!current_team_member&.admin?
  end

  def require_current_team_admin
    unless current_team_admin?
      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end
end
