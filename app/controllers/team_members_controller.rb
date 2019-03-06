class TeamMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team
  before_action :require_non_personal_team!
  before_action :set_team_member, only: [:edit, :update, :destroy, :switch]

  # GET /teams
  def index
    redirect_to @team
  end

  # GET /team_members/1
  def show
    redirect_to @team
  end

  # GET /team_members/new
  def new
    @team_member = TeamMember.new
  end

  # GET /team_members/1/edit
  def edit
  end

  # POST /team_members
  def create
    user = User.invite!({ name: params[:name], email: params[:email] }, current_user)
    if user.persisted?
      @team.team_members.create(user: user, admin: params[:admin])
      redirect_to @team, notice: 'Team member was successfully added.'
    else
      render :new
    end
  end

  # PATCH/PUT /team_members/1
  def update
    if @team_member.update(team_member_params)
      redirect_to @team, notice: 'Team member was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /team_members/1
  def destroy
    @team_member.destroy
    redirect_to @team, notice: 'Team member was successfully removed.'
  end

  private
    def set_team
      @team = current_user.teams.find(params[:team_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team_member
      @team_member = @team.team_members.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_member_params
      attrs = [:user_id] + TeamMember.local_stored_attributes[:roles]
      params.require(:team_member).permit(*attrs)
    end

    def require_non_personal_team!
      redirect_to teams_path if @team.personal?
    end
end
