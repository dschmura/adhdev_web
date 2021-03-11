class Users::SudoController < ActionController::Base
  before_action :authenticate_user!

  def create
    if current_user.valid_password?(params[:password])
      session[:sudo] = Time.current.to_s
      redirect_to params[:redirect_to]
    else
      flash[:alert] = I18n.t("users.sudo.invalid_password")
      render :new, status: :unprocessable_entity
    end
  end
end
