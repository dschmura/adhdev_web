module Jumpstart
  module SubscriptionExtensions
    extend ActiveSupport::Concern

    def plan
      @plan ||= Plan.where("details @> ?", {"#{customer.processor}_id": processor_plan}.to_json).first
    end

    def plan_interval
      plan.interval
    end
  end
end
