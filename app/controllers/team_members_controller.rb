class TeamMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team_member, only: [:show, :edit, :update, :destroy, :switch]

  # GET /teams
  def index
    redirect_to current_team
  end

  # GET /team_members/1
  def show
  end

  # GET /team_members/new
  def new
    @team_member = current_team.team_members.new
  end

  # GET /team_members/1/edit
  def edit
  end

  # POST /team_members
  def create
    user = User.invite!({ email: params[:email] }, current_user)
    if user.persisted?
      current_team.team_members.create(user: user, admin: params[:admin])
      redirect_to current_team, notice: 'Team member was successfully added.'
    else
      render :new
    end
  end

  # PATCH/PUT /team_members/1
  def update
    if @team_member.update(team_member_params)
      redirect_to @team_member, notice: 'Team member was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /team_members/1
  def destroy
    @team_member.destroy
    redirect_to team_members_url, notice: 'Team member was successfully removed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_member
      @team_member = current_team.team_members.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_member_params
      params.require(:team_member).permit(:user_id, :admin)
    end
end
