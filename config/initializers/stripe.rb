module Pay
  module Stripe

    class ChargeSucceeded
      def notify_user(user, charge)
        Pay::UserMailer.receipt(user, charge).deliver_later
      end
    end

    class ChargeRefunded
      def notify_user(user, charge)
        Pay::UserMailer.refund(user, charge).deliver_later
      end
    end

    class SubscriptionRenewing
      def notify_user(user, subscription)
        # We only want to notify yearly subscribers of their renewal.
        # Monthly renewals don't need a warning.
        yearly_plan_ids = Jumpstart.config.yearly_plans.map{ |p| p["stripe_id"] }
        if yearly_plan_ids.include? subscription.stripe_id
          Pay::UserMailer.subscription_renewing(user, subscription).deliver_later
        end
      end
    end

  end
end
