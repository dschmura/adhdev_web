class Api::V1::TeamsController < Api::BaseController
  def index
    render partial: "teams/team", collection: current_user.teams, as: :team
  end
end
