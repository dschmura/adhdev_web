module Jumpstart
  class JobProcessor
    AVAILABLE_PROVIDERS = {
      "Async"       => :async,
      "Sidekiq"     => :sidekiq,
      "DelayedJob"  => :delayed_job,
      "Sneakers"    => :sneakers,
      "SuckerPunch" => :sucker_punch,
    }.freeze

    def self.command(processor)
      case processor.to_s
      when "async"
      when "sidekiq"
        "bundle exec sidekiq"
      when "delayed_job"
        "bin/delayed_job --queues=default,mailers start"
      when "sneakers"
        "rake sneakers:run"
      when "sucker_punch"
      end
    end
  end
end
