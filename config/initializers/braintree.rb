Pay.setup do |config|
  config.braintree_gateway = Braintree::Gateway.new(
    environment: :sandbox,
    merchant_id: Rails.application.credentials.dig(:development, :braintree, :merchant_key),
    public_key:  Rails.application.credentials.dig(:development, :braintree, :public_key),
    private_key: Rails.application.credentials.dig(:development, :braintree, :private_key)
  )
end
