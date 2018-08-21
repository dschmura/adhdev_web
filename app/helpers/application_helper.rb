module ApplicationHelper
  def avatar_url_for(user, opts={})
    size = opts[:size] || 48

    if user.avatar.attached?
      user.avatar.variant(combine_options: {
        thumbnail: "#{size}x#{size}^",
        gravity: "center",
        extent: "#{size}x#{size}"
      })
    else
      hash = Digest::MD5.hexdigest(current_user.email)
      "https://secure.gravatar.com/avatar/#{hash}.png?height=#{size}&width=#{size}"
    end
  end
end
