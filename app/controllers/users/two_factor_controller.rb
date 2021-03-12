class Users::TwoFactorController < ActionController::Base
  before_action :authenticate_user!

  def create
    if current_user.valid_code?(params[:code])
      session[:two_factor] = Time.current.to_s
      redirect_to params[:redirect_to]
    else
      flash[:alert] = I18n.t("users.two_factor.invalid")
      render :new, status: :unprocessable_entity
    end
  end
end
