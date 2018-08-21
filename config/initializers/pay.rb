Pay.setup do |config|
  credentials = Rails.application.credentials
  env         = Rails.env.to_sym
  merchant_id = credentials.dig(env, :braintree, :merchant_key)

  if merchant_id.present?
    config.braintree_gateway = ::Braintree::Gateway.new(
      environment: credentials.dig(env, :braintree, :environment).to_sym,
      merchant_id: merchant_id,
      public_key:  credentials.dig(env, :braintree, :public_key),
      private_key: credentials.dig(env, :braintree, :private_key)
    )
  end
end
