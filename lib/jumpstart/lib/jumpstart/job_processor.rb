module Jumpstart
  class JobProcessor
    AVAILABLE_PROVIDERS = {
      "Async" => :async,
      "Sidekiq" => :sidekiq,
      "DelayedJob" => :delayed_job,
      "Sneakers" => :sneakers,
      "SuckerPunch" => :sucker_punch
    }.freeze

    def self.command(processor)
      # async, sucker_punch don't need separate processes
      case processor.to_s
      when "sidekiq"
        "bundle exec sidekiq"
      when "delayed_job"
        "bin/delayed_job --queues=default,mailers start"
      when "sneakers"
        "rake sneakers:run"
      end
    end

    def self.sidekiq_config
      <<~YAML
        # Sample configuration file for Sidekiq.
        # Options here can still be overridden by cmd line args.
        # Place this file at config/sidekiq.yml and Sidekiq will
        # pick it up automatically.
        ---
        :verbose: false
        :concurrency: 10

        # Set timeout to 8 on Heroku, longer if you manage your own systems.
        :timeout: 30

        # Sidekiq will run this file through ERB when reading it so you can
        # even put in dynamic logic, like a host-specific queue.
        # http://www.mikeperham.com/2013/11/13/advanced-sidekiq-host-specific-queues/
        :queues:
          - critical
          - default
          - <%= `hostname`.strip %>
          - mailers
          - low

        # you can override concurrency based on environment
        production:
          :concurrency: 25
        staging:
          :concurrency: 15
      YAML
    end
  end
end
