# Extend the Pay Stripe webhooks to send receipts

module Webhooks
  module ChargeSucceededExtension
    def notify_user(billable, charge)
      Pay::UserMailer.with(billable: billable, charge: charge).receipt.deliver_later
    end
  end

  module ChargeRefundedExtension
    def notify_user(billable, charge)
      Pay::UserMailer.with(billable: billable, charge: charge).refund.deliver_later
    end
  end

  module SubscriptionRenewingExtension
    def notify_user(billable, subscription, date)
      # We only want to notify yearly subscribers of their renewal.
      # Monthly renewals don't need a warning.
      yearly_plan_ids = Jumpstart.config.yearly_plans.map { |p| p["stripe_id"] }
      if yearly_plan_ids.include? subscription.processor_id
        Pay::UserMailer.with(billable: billable, subscription: subscription, date: date).subscription_renewing.deliver_later
      end
    end
  end
end

Rails.application.config.to_prepare do
  if Jumpstart.config.stripe?
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
