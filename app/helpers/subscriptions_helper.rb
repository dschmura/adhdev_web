module SubscriptionsHelper
  def braintree_env
    Rails.env.production? ? 'production' : 'sandbox'
  end

  def payment_method_details
    if current_team.paypal?
      "#{current_team.card_type} #{current_team.card_last4}"
    else
      "#{current_team.card_type} ending in #{current_team.card_last4}"
    end
  end
end
