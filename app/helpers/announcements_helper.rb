module AnnouncementsHelper
  def unread_announcements_class(user)
    announcement = Announcement.order(published_at: :desc).first
    return if announcement.nil?

    # Highlight announcements for anyone not logged in, cuz tempting
    if user.nil? || user.announcements_read_at.nil? ||
        user.announcements_read_at < announcement.published_at
      "unread-announcements"
    end
  end
end
