module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip

      Current.user = current_user

      # TODO: Find account by domain, subdomain, and path
      Current.account = current_user.accounts.find_by(id: session[:account_id])

      # Fallback to first account
      Current.account ||= current_user.accounts.first

      # Fallback to personal account if no accounts exist
      Current.account ||= current_user.create_personal_account
    end
  end
end

