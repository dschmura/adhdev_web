module Users
  module NavbarNotifications
    extend ActiveSupport::Concern

    included do
      before_action :set_notifications, if: :user_signed_in?
    end

    def set_notifications
      @notifications = current_user.notifications.newest_first.limit(10)
    end
  end
end
