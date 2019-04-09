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

  def announcement_class(type)
    {
      "new" => "text-success",
      "update" => "text-warning",
      "fix" => "text-danger",
    }.fetch(type, "text-success")
  end
end
