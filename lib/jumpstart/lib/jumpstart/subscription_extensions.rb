module Jumpstart
  module SubscriptionExtensions
    extend ActiveSupport::Concern

    def plan
      query = {"#{processor}_id": processor_plan}
      Plan.where("details @> ?", query.to_json).first
    end

    def plan_interval
      plan.interval
    end
  end
end
