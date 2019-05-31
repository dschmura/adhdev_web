module Jumpstart
  class JobProcessor
    AVAILABLE_PROVIDERS = {
      "Async"       => :async,
      "Sidekiq"     => :sidekiq,
      "DelayedJob"  => :delayed_job,
      "Sneakers"    => :sneakers,
      "SuckerPunch" => :sucker_punch,
    }.freeze
  end
end
