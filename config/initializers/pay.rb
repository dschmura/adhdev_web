Pay.setup do |config|
  credentials = Rails.application.credentials.dig(Rails.env.to_sym, :braintree)
  merchant_id = credentials.dig(:merchant_key)

  if merchant_id.present?
    config.braintree_gateway = ::Braintree::Gateway.new(
      environment: credentials.dig(:environment).to_sym,
      merchant_id: merchant_id,
      public_key:  credentials.dig(:public_key),
      private_key: credentials.dig(:private_key)
    )
  end
end
