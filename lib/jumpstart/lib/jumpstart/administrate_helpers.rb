module Jumpstart
  module AdministrateHelpers

    def charge_processor_url(charge)
      case charge.processor
      when "stripe"
        "https://dashboard.stripe.com/payments/#{charge.processor_id}"

      when "braintree"
        config      = Pay.braintree_gateway.config
        merchant_id = config.merchant_id
        environment = (config.environment.to_s == "sandbox" ? "sandbox" : "www")

        "https://#{environment}.braintreegateway.com/merchants/#{merchant_id}/transactions/#{charge.processor_id}"
      end
    end

    def customer_processor_url(user)
      case user.processor
      when "stripe"
        "https://dashboard.stripe.com/customers/#{user.processor_id}"

      when "braintree"
        config      = Pay.braintree_gateway.config
        merchant_id = config.merchant_id
        environment = (config.environment.to_s == "sandbox" ? "sandbox" : "www")

        "https://#{environment}.braintreegateway.com/merchants/#{merchant_id}/customers/#{user.processor_id}"
      end
    end

    def subscription_processor_url(subscription)
      case subscription.processor
      when "stripe"
        "https://dashboard.stripe.com/subscriptions/#{subscription.processor_id}"

      when "braintree"
        config      = Pay.braintree_gateway.config
        merchant_id = config.merchant_id
        environment = (config.environment.to_s == "sandbox" ? "sandbox" : "www")

        "https://#{environment}.braintreegateway.com/merchants/#{merchant_id}/subscriptions/#{subscription.processor_id}"
      end
    end

  end
end
