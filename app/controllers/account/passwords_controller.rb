class Account::PasswordsController < ApplicationController
  before_action :authenticate_user!

  def show
    redirect_to action: :edit
  end

  def edit
  end

  def update
    if current_user.update_with_password(password_params)
      bypass_sign_in current_user
      redirect_to account_password_path, notice: "Your password was changed successfully"
    else
      render action: :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
