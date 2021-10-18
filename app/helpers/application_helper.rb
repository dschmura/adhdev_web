module ApplicationHelper
  include Pagy::Frontend

  def avatar_url_for(user, opts = {})
    size = opts[:size] || 48

    if user.respond_to?(:avatar) && user.avatar.attached? && user.avatar.variable?
      user.avatar.variant(
        thumbnail: "#{size}x#{size}^",
        gravity: "center",
        extent: "#{size}x#{size}"
      )
    else
      gravatar_url_for(user.email, size: size)
    end
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
    weight = options.delete(:weight) || "far"
    options[:class] = [weight, "fa-#{name}", options.delete(:class)]
    tag.i(nil, **options)
  end

  def badge(text, options = {})
    base = options.delete(:base) || "rounded py-0.5 px-2 text-xs inline-block font-semibold leading-normal mr-2"
    color = options.delete(:color) || "bg-gray-100 text-gray-800"
    options[:class] = Array.wrap(options[:class]) + [base, color]
    tag.div(text, **options)
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def viewport_meta_tag(content: "width=device-width, initial-scale=1", turbo_native: "maximum-scale=1.0, user-scalable=0")
    full_content = [content, (turbo_native if turbo_native_app?)].compact.join(", ")
    tag.meta name: "viewport", content: full_content
  end
end
