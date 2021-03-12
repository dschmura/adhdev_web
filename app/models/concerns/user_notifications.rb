module UserNotifications
  extend ActiveSupport::Concern

  before_destroy :destroy_notifications

  def notifications
    @notifications ||= Notification.where(params: { user: self })
  end

  def destroy_notifications
    notifications.destroy_all
  end
end
