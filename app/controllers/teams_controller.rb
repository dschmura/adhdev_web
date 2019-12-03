class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:show, :edit, :update, :destroy, :switch]

  # GET /teams
  def index
    @pagy, @teams = pagy(current_user.teams)
  end

  # GET /teams/1
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  def create
    @team = Team.new(team_params.merge(owner: current_user))
    @team.team_members.new(user: current_user, admin: true)

    if @team.save
      set_active_team
      redirect_to @team, notice: 'Team was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to @team, notice: 'Team was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully destroyed.'
  end

  def switch
    set_active_team
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = current_user.teams.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name)
    end

    def set_active_team
      session[:team_id] = @team.id
    end

end
