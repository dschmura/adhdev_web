class ApplicationController < ActionController::Base
  include Jumpstart::Controller
  include Teams::SubscriptionStatus
  include Users::TimeZone
  include Pagy::Backend
  include CurrentHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :masquerade_user!

  protected

    # To add extra fields to Devise registration, add the attribute names to `extra_keys`
    def configure_permitted_parameters
      extra_keys  = [:avatar, :name, :time_zone]
      signup_keys = extra_keys + [:terms_of_service]
      devise_parameter_sanitizer.permit(:sign_up,           keys: signup_keys)
      devise_parameter_sanitizer.permit(:account_update,    keys: extra_keys)
      devise_parameter_sanitizer.permit(:accept_invitation, keys: extra_keys)
    end
end
