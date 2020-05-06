class AccountUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  before_action :require_non_personal_account!
  before_action :set_account_user, only: [:edit, :update, :destroy, :switch]
  before_action :require_admin, except: [:index, :show]

  # GET /accounts
  def index
    redirect_to @account
  end

  # GET /account_users/1
  def show
    redirect_to @account
  end

  # GET /account_users/1/edit
  def edit
  end

  # PATCH/PUT /account_users/1
  def update
    if @account_user.update(account_user_params)
      redirect_to @account, notice: "Account member was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /account_users/1
  def destroy
    @account_user.destroy
    redirect_to @account, notice: "Account member was successfully removed."
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:account_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_account_user
    @account_user = @account.account_users.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def account_user_params
    params.require(:account_user).permit(*AccountUser::ROLES)
  end

  def require_non_personal_account!
    redirect_to accounts_path if @account.personal?
  end

  def require_admin
    account_user = @account.account_users.find_by(user: current_user)
    if account_user.nil? || !account_user.admin?
      redirect_to account_path(@account), notice: "You must be a account admin to do that."
    end
  end
end
