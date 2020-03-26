# Extend the Pay Stripe webhooks to send receipts

module Webhooks
  module ChargeSucceededExtension
    def notify_user(user, charge)
      Pay::UserMailer.receipt(user, charge).deliver_later
    end
  end

  module ChargeRefundedExtension
    def notify_user(user, charge)
      Pay::UserMailer.refund(user, charge).deliver_later
    end
  end

  module SubscriptionRenewingExtension
    def notify_user(user, subscription)
      # We only want to notify yearly subscribers of their renewal.
      # Monthly renewals don't need a warning.
      yearly_plan_ids = Jumpstart.config.yearly_plans.map { |p| p["stripe_id"] }
      if yearly_plan_ids.include? subscription.stripe_id
        Pay::UserMailer.subscription_renewing(user, subscription).deliver_later
      end
    end
  end
end

Rails.application.config.to_prepare do
  if defined?(StripeEvent) && Jumpstart.config.stripe?
    require "pay/stripe/webhooks"

    class Pay::Stripe::Webhooks::ChargeSucceeded
      prepend Webhooks::ChargeSucceededExtension
    end

    class Pay::Stripe::Webhooks::ChargeRefunded
      prepend Webhooks::ChargeRefundedExtension
    end

    class Pay::Stripe::Webhooks::SubscriptionRenewing
      prepend Webhooks::SubscriptionRenewingExtension
    end
  end
end
