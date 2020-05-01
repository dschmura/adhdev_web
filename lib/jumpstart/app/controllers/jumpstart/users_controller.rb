require_dependency "jumpstart/application_controller"

module Jumpstart
  class UsersController < ApplicationController
    def create
      user = User.new(user_params)

      if user.save
        # Ensure Jumpstart free plan exists for admin users
        Plan.create_with(name: "Free", interval: :month, trial_period_days: 0).find_or_create_by(details: { jumpstart_id: :free })

        # Create a fake subscription for the admin user so they have access to everything by default
        user.accounts.first.subscriptions.create(subscription_params)

        redirect_to root_path(anchor: :users), notice: "#{user.name} (#{user.email}) has been added as an admin."
      else
        redirect_to root_path(anchor: :users), alert: "Unable to save user. Make sure to fill out all fields and have a strong enough password."
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :terms_of_service).merge(admin: true)
    end

    def subscription_params
      {name: "default", processor: :jumpstart, processor_id: :free, processor_plan: :free, quantity: 1, status: :active}
    end
  end
end
