module SubscriptionsHelper
  def braintree_env
    Rails.env.production? ? 'production' : 'sandbox'
  end

  def payment_method_details
    if current_user.paypal?
      "#{current_user.card_brand} #{current_user.card_last4}"
    else
      "#{current_user.card_brand} ending in #{current_user.card_last4}"
    end
  end
end
