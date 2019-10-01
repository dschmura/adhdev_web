require_dependency "jumpstart/application_controller"

module Jumpstart
  class UsersController < ApplicationController
    def create
      user = User.new(user_params)

      if user.save
        redirect_to root_path(anchor: :users), notice: "#{user.name} (#{user.email}) has been added as an admin."
      else
        redirect_to root_path(anchor: :users), alert: "Unable to save user. Make sure to fill out all fields and have a strong enough password.password"
      end
    end

    private

    def user_params
      params.require(:user).  permit(:name, :email, :password, :password_confirmation).merge(admin: true)
    end
  end
end
