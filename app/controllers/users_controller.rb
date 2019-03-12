class UsersController < ApplicationController
  def index
    @users = User.all.with_attached_avatar

    respond_to do |format|
      format.json
    end
  end
end
