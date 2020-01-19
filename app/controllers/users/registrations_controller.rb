class Users::RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: :create

  protected

  def build_resource(hash = {})
    self.resource = resource_class.new_with_session(hash, session)

    # Jumpstart: Skip email confirmation on registration.
    #   Require confirmation when user changes their email only
    self.resource.skip_confirmation!
  end

  def update_resource(resource, params)
    # Jumpstart: Allow user to edit their profile without password
    resource.update_without_password(params)
  end
end
