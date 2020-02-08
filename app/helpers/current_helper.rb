module CurrentHelper
  def current_account
    @current_account ||= current_user.accounts.find(session[:account_id])
  rescue ActiveRecord::RecordNotFound
    @current_account ||= current_user.accounts.first
    @current_account ||= current_user.create_personal_account
  end

  def current_account_user
    @current_account_user ||= current_account.account_users.find_by(user: current_user)
  end

  def current_roles
    current_account_user.active_roles
  end

  def current_account_admin?
    !!current_account_user&.admin?
  end

  def require_current_account_admin
    unless current_account_admin?
      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end
end
