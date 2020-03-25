class Api::V1::UsersController < Api::BaseController
  skip_before_action :authenticate_api_token!, only: [:create]
  before_action :configure_permitted_parameters, only: [:create]

  def create
    user = User.new(devise_parameter_sanitizer.sanitize(:sign_up))
    api_token = user.api_tokens.new(name: "default")

    if user.save
      render json: {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          api_tokens: [{
            id: api_token.id,
            name: api_token.name,
            token: api_token.token
          }]
        }
      }

    else
      render json: {errors: user.errors}
    end
  end

  private

  def devise_parameter_sanitizer
    @devise_parameter_sanitizer ||= Devise::ParameterSanitizer.new(User, :user, params)
  end
end
