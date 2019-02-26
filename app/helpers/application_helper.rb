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
      hash = Digest::MD5.hexdigest(user.email)
      "https://secure.gravatar.com/avatar/#{hash}.png?height=#{size}&width=#{size}"
    end
  end

  def nav_link_to(title, path, options={})
    options[:class] = Array.wrap(options[:class])
    active_class    = options.delete(:active_class) || "active"
    inactive_class  = options.delete(:inactive_class) || ""

    active = if options[:starts_with]
               request.path.start_with?(options[:starts_with])
             else
               request.path == path
             end

    classes         = active ? active_class : inactive_class
    options[:class] << classes

    link_to title, path, options
  end

  def disable_with(text)
    "<i class=\"far fa-spinner-third fa-spin\"></i> #{text}".html_safe
  end

  def render_svg(name, styles: "fill-current text-grey", title: nil)
    filename = "#{name}.svg"
    title ||= name.underscore.humanize
    inline_svg(filename, aria: true, nocomment: true, title: title, class: styles)
  end
end
