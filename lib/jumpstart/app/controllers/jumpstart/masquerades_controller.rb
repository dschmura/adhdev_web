class Jumpstart::MasqueradesController < Devise::MasqueradesController
  protected

  def masquerade_authorize!
    current_user.admin?
  end
end
