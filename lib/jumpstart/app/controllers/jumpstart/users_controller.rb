require_dependency "jumpstart/application_controller"

module Jumpstart
  class UsersController < ApplicationController
    def create
      @user = User.new(user_params)

      if @user.save
        # Ensure Jumpstart free plan exists for admin users
        Plan.where(name: "Free").first_or_create(hidden: true, amount: 0, currency: :usd, interval: :month, trial_period_days: 0, fake_processor_id: :free)

        # Create a fake subscription for the admin user so they have access to everything by default
        account = @user.accounts.first
        account.set_payment_processor :fake_processor, allow_fake: true
        account.payment_processor.subscribe plan: :free

        @notice = "#{@user.name} (#{@user.email}) has been added as an admin. #{view_context.link_to("Login", main_app.new_user_session_path)}"

        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to root_path(anchor: :users), notice: @notice }
        end
      else
        render partial: "jumpstart/admin/admin_user_modal", locals: {user: @user}
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :time_zone).merge(admin: true, terms_of_service: true)
    end
  end
end
