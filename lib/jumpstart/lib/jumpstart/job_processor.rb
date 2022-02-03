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
  end
end
