class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:show, :edit, :update, :destroy, :switch]
  before_action :require_admin, only: [:edit, :update, :destroy]
  before_action :prevent_personal_account_deletion, only: [:destroy]

  # GET /accounts
  def index
    @pagy, @accounts = pagy(current_user.accounts)
  end

  # GET /accounts/1
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  def create
    @account = Account.new(account_params.merge(owner: current_user))
    @account.account_users.new(user: current_user, admin: true)

    if @account.save
      set_active_account
      redirect_to @account, notice: "Account was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      redirect_to @account, notice: "Account was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy
    redirect_to accounts_url, notice: "Account was successfully destroyed."
  end

  def switch
    # This is not enabled by default, because we can't guarantee the domain is configured properly.
    # Uncomment this if you would like to redirect to the custom domain when switching accounts.
    # if Jumpstart::Multitenancy.domain? && @account.domain?
    #  redirect_to @account.domain

    if Jumpstart::Multitenancy.subdomain? && @account.subdomain?
      redirect_to root_url(subdomain: @account.subdomain)

    elsif Jumpstart::Multitenancy.path?
      redirect_to root_url(script_name: "/#{@account.id}")

    else
      session[:account_id] = @account.id
      redirect_to root_path
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def account_params
    attributes = [:name]
    attributes << :domain if Jumpstart::Multitenancy.domain?
    attributes << :subdomain if Jumpstart::Multitenancy.subdomain?
    params.require(:account).permit(*attributes)
  end

  def set_active_account
    session[:account_id] = @account.id
  end

  def require_admin
    account_user = @account.account_users.find_by(user: current_user)
    if account_user.nil? || !account_user.admin?
      redirect_to account_path(@account), alert: "You must be a account admin to do that."
    end
  end

  def prevent_personal_account_deletion
    if @account.personal?
      redirect_to account_path(@account), alert: "You cannot delete your personal account."
    end
  end
end
