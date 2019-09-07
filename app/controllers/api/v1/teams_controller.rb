class Api::V1::TeamsController < Api::BaseController
  def index
    @teams = current_user.teams
    render "teams/index"
  end
end
