Pay.setup do |config|
  config.application_name = Jumpstart.config.application_name
  config.business_name = Jumpstart.config.business_name
  config.business_address = Jumpstart.config.business_address
  config.support_email = Jumpstart.config.support_email

  config.routes_path = "/"
end

module SubscriptionExtensions
  extend ActiveSupport::Concern

  def jumpstart_paused?
    false
  end

  def jumpstart_on_grace_period?
    false
  end
end

Rails.configuration.to_prepare do
  Pay.subscription_model.include SubscriptionExtensions
end
