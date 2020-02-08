class Current < ActiveSupport::CurrentAttributes
  attribute :user, :account

  resets { Time.zone = nil }

  def user=(user)
    super
    Time.zone = user.time_zone
  end

  def account_user
    @account_user ||= account.account_users.find_by(user: user)
  end

  def roles
    account_user.active_roles
  end

  def account_admin?
    !!account_user&.admin?
  end
end
