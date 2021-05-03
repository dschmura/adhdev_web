class Users::TwoFactorController < ActionController::Base
  before_action :authenticate_user!

  def create
    current_user.enable_two_factor!
    @codes = current_user.generate_otp_backup_codes!
  end

  def destroy
    current_user.disable_two_factor!
  end
end
