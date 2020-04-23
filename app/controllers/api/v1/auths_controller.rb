class Api::V1::AuthsController < Api::BaseController
  skip_before_action :authenticate_api_token!

  # Requires email and password params
  # Returns an API token for the user if valid
  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      render json: {
        token: user.api_tokens.find_or_create_by(name: "default").token
      }
    else
      head :unauthorized
    end
  end
end
