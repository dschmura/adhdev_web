require "rollbar"

Rollbar.configure do |config|
  config.access_token = Rails.application.credentials.rollbar[:access_token]
  # Other Configuration Settings
end
