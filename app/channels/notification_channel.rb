class NotificationChannel < Noticed::NotificationChannel
  def mark_as_interacted(data)
    current_user.notifications.where(id: data["ids"]).mark_as_interacted!
  end
end
