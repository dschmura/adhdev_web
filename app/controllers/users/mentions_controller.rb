class Users::MentionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.search_by_full_name(params[:query]).with_attached_avatar

    respond_to do |format|
      format.json
    end
  end
end
