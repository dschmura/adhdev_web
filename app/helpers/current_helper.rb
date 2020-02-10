module CurrentHelper
  def current_account
    Current.account
  end

  def current_account_user
    Current.account_user
  end

  def current_roles
    Current.roles
  end

  def current_account_admin?
    Current.account_admin?
  end
end
