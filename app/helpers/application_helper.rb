module ApplicationHelper
  include Pagy::Frontend

  def avatar_url_for(user, opts = {})
    size = opts[:size] || 48

    if user.respond_to?(:avatar) && user.avatar.attached? && user.avatar.variable?
      user.avatar.variant(combine_options: {
        thumbnail: "#{size}x#{size}^",
        gravity: "center",
        extent: "#{size}x#{size}"
      })
    else
      hash = Digest::MD5.hexdigest(user.email.downcase)
      "https://secure.gravatar.com/avatar/#{hash}.png?height=#{size}&width=#{size}"
    end
  end

  def nav_link_to(title, path, options = {})
    options[:class] = Array.wrap(options[:class])
    active_class = options.delete(:active_class) || "active"
    inactive_class = options.delete(:inactive_class) || ""

    active = if (paths = Array.wrap(options[:starts_with])) && paths.present?
      paths.any? { |path| request.path.start_with?(path) }
    else
      request.path == path
    end

    classes = active ? active_class : inactive_class
    options[:class] << classes

    link_to title, path, options
  end

  def disable_with(text)
    "<i class=\"far fa-spinner-third fa-spin\"></i> #{text}".html_safe
  end

  def render_svg(name, options = {})
    options[:title] ||= name.underscore.humanize
    options[:aria] = true
    options[:nocomment] = true
    options[:class] = options.fetch(:styles, "fill-current text-gray-500")

    filename = "#{name}.svg"
    inline_svg_tag(filename, options)
  end

  def fa_icon(name, options = {})
    weight = options[:weight] || "far"
    classes = [weight, "fa-#{name}", options[:class]]
    content_tag :i, nil, class: classes
  end

  def badge(text, options = {})
    base = options.delete(:base) || "rounded-full py-1 px-4 text-xs inline-block font-bold leading-normal uppercase mr-2"
    color = options.delete(:color) || "bg-gray-400 text-gray-700"

    options[:class] = Array.wrap(options[:class]) + [base, color]

    content_tag :div, text, options
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
end
