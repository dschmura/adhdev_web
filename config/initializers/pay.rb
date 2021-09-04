Pay.setup do |config|
  config.application_name = Jumpstart.config.application_name
  config.business_name = Jumpstart.config.business_name
  config.business_address = Jumpstart.config.business_address
  config.support_email = Jumpstart.config.support_email

  config.routes_path = "/"
end

module SubscriptionExtensions
  extend ActiveSupport::Concern

  included do
    # Generates hash IDs with a friendly prefix so users can't guess hidden plan IDs on checkout
    # https://github.com/excid3/prefixed_ids
    has_prefix_id :sub
  end

  def jumpstart_paused?
    false
  end

  def jumpstart_on_grace_period?
    false
  end
end

module ChargeExtensions
  extend ActiveSupport::Concern

  included do
    # Generates hash IDs with a friendly prefix so users can't guess hidden plan IDs on checkout
    # https://github.com/excid3/prefixed_ids
    has_prefix_id :ch
  end
end

Rails.configuration.to_prepare do
  Pay::Subscription.include SubscriptionExtensions
  Pay::Charge.include ChargeExtensions
end
