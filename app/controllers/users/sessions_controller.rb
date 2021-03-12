class Users::SessionsController < Devise::SessionsController
  prepend_before_action :authenticate_with_two_factor, only: [:create]

  def authenticate_with_two_factor
    self.resource = find_user
    return unless resource
    return unless resource.otp_required_for_login?

    # Submitted email and password, save user ID and send along to OTP
    if sign_in_params[:password] && resource.valid_password?(sign_in_params[:password])
      session[:otp_user_id] = resource.id
      render :otp, status: :unprocessable_entity

    # Submitted OTP, so verify and login
    elsif session[:otp_user_id] && params[:otp_attempt]
      if resource.verify_and_consume_otp!(params[:otp_attempt])
        session.delete(:otp_user_id)
        sign_in(resource, event: :authentication)
      else
        flash.now[:alert] = "Incorrect verification code"
        render :otp, status: :unprocessable_entity
      end
    end
  end

  def find_user
    if session[:otp_user_id]
      User.find(session[:otp_user_id])

    elsif sign_in_params[:email]
      User.find_by(email: sign_in_params[:email])
    end
  end
end
