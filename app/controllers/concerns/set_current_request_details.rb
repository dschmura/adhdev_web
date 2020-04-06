module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    set_current_tenant_through_filter

    before_action do
      Current.request_id = request.uuid
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
      Current.user = current_user

      # Account may already be set by the AccountMiddleware

      if Jumpstart::Multitenancy.domain?
        Current.account ||= Account.find_by(domain: request.domain)
      end

      if Jumpstart::Multitenancy.subdomain?
        Current.account ||= Account.find_by(subdomain: request.subdomains.first)
      end

      if Jumpstart::Multitenancy.session? && user_signed_in?
        Current.account ||= current_user.accounts.find_by(id: session[:account_id])
      end

      # Fallback accounts
      if user_signed_in?
        Current.account ||= current_user.accounts.order(created_at: :asc).first
        Current.account ||= current_user.create_default_account
      end

      set_current_tenant(Current.account)
    end
  end
end
