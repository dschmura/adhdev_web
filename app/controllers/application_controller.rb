class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SetCurrentRequestDetails
  include Jumpstart::Controller
  include Accounts::SubscriptionStatus
  include Users::TimeZone
  include Pagy::Backend
  include CurrentHelper
  include Sortable

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :masquerade_user!

  protected

  # To add extra fields to Devise registration, add the attribute names to `extra_keys`
  def configure_permitted_parameters
    extra_keys = [:avatar, :name, :time_zone]
    signup_keys = extra_keys + [:terms_of_service, :invite, owned_accounts_attributes: [:name]]
    devise_parameter_sanitizer.permit(:sign_up, keys: signup_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_keys)
    devise_parameter_sanitizer.permit(:accept_invitation, keys: extra_keys)
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  # Helper method for verifying authentication in a before_action, but redirecting to sign up instead of login
  def authenticate_user_with_sign_up!
    unless user_signed_in?
      store_location_for(:user, request.fullpath)
      redirect_to new_user_registration_path, alert: "Please create an account first"
    end
  end

  def require_current_account_admin
    unless current_account_admin?
      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end
end
