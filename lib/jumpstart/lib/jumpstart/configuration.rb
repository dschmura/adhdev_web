require "jumpstart/configuration/mailable"
require "jumpstart/configuration/payable"

module Jumpstart
  class Configuration
    include ActiveModel::Model
    include Mailable
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
      super(options)
      self.application_name ||= "Jumpstart"
      self.business_name ||= "Jumpstart Company, LLC"
      self.domain ||= "example.com"
      self.support_email ||= "support@example.com"
      self.default_from_email ||= "Jumpstart <support@example.com>"
      self.job_processor ||= "async"
    end

    def save
      File.write(self.class.config_path, to_yaml)
      save_gemfile
      update_procfiles
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
      gems[:main] += [{ name: "stripe" }, { name: "stripe_event" }] if stripe?
      gems[:test] += [{ name: "stripe-ruby-mock", github: 'rebelidealist/stripe-ruby-mock' }] if stripe?
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
      write_file Rails.root.join("Procfile.dev"), procfile_content(webpack_dev_server: true)
    end

    private

      def procfile_content(webpack_dev_server: false)
        content = ["web: bundle exec rails s"]
        content << "webpack: bin/webpack-dev-server" if webpack_dev_server

        if worker_command = Jumpstart::JobProcessor.command(job_processor)
          content << "worker: #{worker_command}"
        end

        content.join("\n")
      end

      def write_file(path, content)
        File.open(path, "wb") { |file| file.write(content) }
      end
  end
end
