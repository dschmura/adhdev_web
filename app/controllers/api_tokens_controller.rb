class ApiTokensController < ApplicationController
  before_action :authenticate_user!
  before_action :set_api_token, only: [:show, :edit, :update, :destroy]

  def index
    @api_tokens = current_user.api_tokens.sorted
  end

  def new
    @api_token = ApiToken.new
  end

  def create
    @api_token = current_user.api_tokens.new(api_token_params)
    if @api_token.save
      redirect_to @api_token, notice: "Successfully created API token"
    else
      render :index
    end
  end

  def edit
  end

  def update
    if @api_token.update(api_token_params)
      redirect_to api_tokens_path, notice: "Successfully updated API token"
    else
      render :edit
    end
  end

  def destroy
    @api_token.destroy
    redirect_to api_tokens_path, notice: "Your API token has been revoked"
  end

  private

  def set_api_token
    @api_token = current_user.api_tokens.find(params[:id])
  end

  def api_token_params
    params.require(:api_token).permit(:name)
  end
end
