require "rails/generators"
require "rails/generators/rails/credentials/credentials_generator"

Rails::Generators::CredentialsGenerator.class_eval do
  def credentials_template
    <<~YAML
      # Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
      secret_key_base: #{SecureRandom.hex(64)}

      # aws:
      #   access_key_id: 123
      #   secret_access_key: 345

      # Jumpstart config
      # ----------------
      # Here you can define global credentials which will be available for all environments.
      # You can override for an environment by nesting them under the environment keys
      # For example:
      #
      # stripe_key: 'xxx'
      # production:
      #   stripe_key: 'yyy'
      #
      # This will use 'yyy' in production, but 'xxx' in any other environment.

      # Login Providers
      # ---------------
      omniauth:
        facebook:
          # https://developers.facebook.com/apps/
          public_key: ''
          private_key: ''

        twitter:
          # https://apps.twitter.com
          public_key: ''
          private_key: ''

        google:
          # https://code.google.com/apis/console/
          public_key: ''
          private_key: ''

      # Mail Providers
      # --------------

      sendgrid:
        # https://app.sendgrid.com/settings/api_keys
        username: ''
        password: ''
        domain: example.com

      ses:
        # https://console.aws.amazon.com/ses/home
        username: ''
        password: ''
        address: ''

      mailjet:
        username: ''
        password: ''
        domain: ''

      mandrill:
        username: ''
        password: ''
        domain: ''

      sparkpost:
        username: ''
        password: ''

      mailgun:
        username: ''
        password: ''

      postmark:
        username: ''
        password: ''

      sendinblue:
        username: ''
        password: ''

      ### Payment Providers

      # Braintree Payments (Required for PayPal support)
      # https://braintreegateway.com
      # https://sandbox.braintreegateway.com
      braintree:
        environment: ''
        public_key: ''
        private_key: ''
        merchant_key: ''

      # Stripe Payments
      # https://dashboard.stripe.com/account/apikeys
      stripe:
        public_key: ''
        private_key: ''

        # For processing Stripe webhooks
        # https://dashboard.stripe.com/account/webhooks
        signing_secret: ''

      development:

      staging:

      production:

    YAML
  end
end
