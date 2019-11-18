require "jumpstart/configuration/mailable"
require "jumpstart/configuration/integratable"
require "jumpstart/configuration/payable"
require "thor"

module Jumpstart
  class Configuration
    include ActiveModel::Model
    include Thor::Actions
    include Mailable
    include Integratable
    include Payable

    # Attributes
    attr_accessor :application_name
    attr_accessor :business_name
    attr_accessor :business_address
    attr_accessor :domain
    attr_accessor :background_job_processor
    attr_accessor :email_provider
    attr_accessor :default_from_email
    attr_accessor :support_email
    attr_accessor :omniauth_providers

    def self.load!
      if File.exists?(config_path)
        config = YAML.load_file(config_path)
        return config if config.is_a?(Jumpstart::Configuration)
        new(config)
      else
        new
      end
    end

    def self.config_path
      Rails.root.join('config', 'jumpstart.yml')
    end

    def self.create_default_config
      FileUtils.cp File.join(File.dirname(__FILE__), '../templates/jumpstart.yml'), config_path
    end

    def initialize(options={})
      assign_attributes(options)
      self.application_name ||= "Jumpstart"
      self.business_name ||= "Jumpstart Company, LLC"
      self.domain ||= "example.com"
      self.support_email ||= "support@example.com"
      self.default_from_email ||= "Jumpstart <support@example.com>"
      self.job_processor ||= "async"
    end

    def save
			# Creates config/jumpstart.yml
      File.write(self.class.config_path, to_yaml)

			# Updates config/jumpstart/Gemfile
      save_gemfile

      update_procfiles
			copy_initializers

			# Change the Jumpstart config to the latest version
      Jumpstart.config = self
    end

    def gemfile_path
      Rails.root.join("config/jumpstart/Gemfile")
    end

    def save_gemfile
      gems = dependencies

      content = ""
      content += format_dependencies(gems[:main]) if gems[:main].any?
      content += "\n\ngroup :test do\n#{format_dependencies(gems[:test], spacing: "  ")}\nend" if gems[:test].any?

      FileUtils.mkdir_p Rails.root.join("config/jumpstart")
      File.write(gemfile_path, content)
    end

    def dependencies
      gems = { main: [], test: [] }
      gems[:main] += Array.wrap(omniauth_providers).map{ |provider| { name: "omniauth-#{provider}" } }
      gems[:main] += [{ name: "airbrake"}] if airbrake?
      gems[:main] += [{ name: "appsignal"}] if appsignal?
      gems[:main] += [{ name: "convertkit-ruby", github: 'excid3/convertkit-ruby', require: 'convertkit'}] if convertkit?
      gems[:main] += [{ name: "gibbon"}] if mailchimp?
      gems[:main] += [{ name: "drip-ruby", require: 'drip'}] if drip?
      gems[:main] += [{ name: "honeybadger"}] if honeybadger?
      gems[:main] += [{ name: "intercom-rails"}] if intercom?
      gems[:main] += [{ name: "rollbar"}] if rollbar?
      gems[:main] += [{ name: "scout_apm" }] if scout?
      gems[:main] += [{ name: "sentry-raven" }] if sentry?
      gems[:main] += [{ name: "skylight" }] if skylight?
      gems[:main] += [{ name: "stripe" }, { name: "stripe_event" }] if stripe?
      gems[:main] << { name: "braintree" } if braintree? || paypal?
      gems[:main] << { name: job_processor.to_s } unless job_processor.to_s == "async"
      gems
    end

    def format_dependencies(group, spacing: "")
      group.map do |details|
        name    = details.delete(:name)
        options = details.map{ |k, v| "#{k}: '#{v}'" }.join(", ")
        line = spacing + "gem '#{name}'"
        line += ", #{options}" if options.present?
        line
      end.join("\n")
    end

    def verify_dependencies!
      content = File.read gemfile_path

      dependencies.each do |group, items|
        return if items.all? { |dependency| content.include?(dependency[:name].to_s) }
      end

      save_gemfile
      puts "It looks like your Jumpstart dependencies are out of sync. We've updated your Jumpstart Gemfile to match the dependencies you have selected.\nRun 'bundle' to install them and then restart your app."
      exit 1
    end

    def job_processor
      (background_job_processor || "async").to_sym
    end

    def omniauth_providers
      Array.wrap(@omniauth_providers)
    end

    def update_procfiles
      write_file Rails.root.join("Procfile"), procfile_content
      write_file Rails.root.join("Procfile.dev"), procfile_content(dev: true)
      write_file Rails.root.join("config", "sidekiq.yml"), JobProcessor.sidekiq_config if job_processor == :sidekiq
    end

		def copy_initializers
      if airbrake?
        copy_template("config/initializers/airbrake.rb")
      end

      if appsignal?
        copy_template("config/appsignal.yml")
      end

			if convertkit?
        copy_template("config/initializers/convertkit.rb")
			end

      if drip?
        copy_template("config/initializers/drip.rb")
      end

      if honeybadger?
        copy_template("config/honeybadger.yml")
      end

      if intercom?
        copy_template("config/initializers/intercom.rb")
      end

      if mailchimp?
        copy_template("config/initializers/mailchimp.rb")
      end

      if rollbar?
        copy_template("config/initializers/rollbar.rb")
      end

      if scout?
        copy_template("config/scout_apm.yml")
      end

      if sentry?
        copy_template("config/initializers/sentry.rb")
      end

      if skylight?
        copy_template("config/skylight.yml")
      end
		end

    private

      def procfile_content(dev: false)
        content = ["web: bundle exec rails s"]

        # Development should use the webpack-dev-server for convenience
        content << "webpack: bin/webpack-dev-server" if dev

        # Background workers
        if worker_command = Jumpstart::JobProcessor.command(job_processor)
          content << "worker: #{worker_command}"
        end

        # Add the Stripe CLI
        content << "stripe: stripe listen --forward-to localhost:5000/webhooks/stripe" if dev && stripe?

        content.join("\n")
      end

      def write_file(path, content)
        File.open(path, "wb") { |file| file.write(content) }
      end

      def copy_template(filename)
        # Safely copy template, so we don't blow away any customizations you made
        if !File.exists?(filename)
          FileUtils.cp(template_path(filename), Rails.root.join(filename))
        end
      end

      def template_path(filename)
        File.join(File.dirname(__FILE__), '../templates/', filename)
      end
  end
end
