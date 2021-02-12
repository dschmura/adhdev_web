module Users
  module NavbarNotifications
    extend ActiveSupport::Concern

    included do
      before_action :set_notifications, if: :user_signed_in?
    end

    def set_notifications
      # Remove the where clause to show notifications for all accounts instead
      @navbar_notifications = current_user.notifications.where(account: current_account).newest_first.limit(10)
    end
  end
end
