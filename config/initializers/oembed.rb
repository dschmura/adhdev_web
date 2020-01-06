OEmbed::Providers.register_all

Rails.application.config.to_prepare do
  ActionText::ContentHelper.allowed_tags += %w(iframe script blockquote time)
  ActionText::ContentHelper.allowed_attributes += ["data-id", "data-flickr-embed", "target"]
end
