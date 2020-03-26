# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# Set ActionMailer Server from Jumpstart
ActionMailer::Base.smtp_settings = Jumpstart::Mailer.new(Jumpstart.config).settings
