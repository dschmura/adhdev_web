require "pagy"
require "pagy/extras/trim"

module Jumpstart
  class Engine < ::Rails::Engine
    isolate_namespace Jumpstart
    engine_name "jumpstart"

    config.app_generators do |g|
      g.templates.unshift File.expand_path("../../templates", __FILE__)
      g.scaffold_stylesheet false
    end

    config.before_initialize do
      Jumpstart.config = Jumpstart::Configuration.load!
      Jumpstart.config.verify_dependencies!
    end

    config.to_prepare do
      Pay.subscription_model.include Jumpstart::SubscriptionExtensions

      Administrate::ApplicationController.helper Jumpstart::AdministrateHelpers
    end

    initializer "jumpstart.setup" do |app|
      # Set ActiveJob from Jumpstart
      ActiveJob::Base.queue_adapter = Jumpstart.config.job_processor

      if Rails.env.production?
        ActionMailer::Base.default_options = {from: Jumpstart.config.default_from_email}
        ActionMailer::Base.default_url_options = {host: Jumpstart.config.domain}
        ActionMailer::Base.smtp_settings = Jumpstart::Mailer.new(Jumpstart.config).settings
      end

      if Rails.env.development?
        # This makes sure we can load the Jumpstart assets in development
        config.assets.precompile << "jumpstart_manifest.js"
      end

      if Jumpstart::Multitenancy.path? || Rails.env.test?
        app.config.middleware.use Jumpstart::AccountMiddleware
      end

      if Jumpstart.config.livereload? && Rails.env.development?
        app.config.middleware.insert_before ActionDispatch::DebugExceptions, Rack::LiveReload
      end
    end
  end
end
