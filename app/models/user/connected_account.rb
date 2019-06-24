# == Schema Information
#
# Table name: user_connected_accounts
#
#  id                               :bigint(8)        not null, primary key
#  auth                             :text
#  encrypted_access_token           :string
#  encrypted_access_token_iv        :string
#  encrypted_access_token_secret    :string
#  encrypted_access_token_secret_iv :string
#  expires_at                       :datetime
#  provider                         :string
#  refresh_token                    :string
#  uid                              :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  user_id                          :bigint(8)
#
# Indexes
#
#  index_connected_accounts_access_token_iv                    (encrypted_access_token_iv) UNIQUE
#  index_connected_accounts_access_token_secret_iv             (encrypted_access_token_secret_iv) UNIQUE
#  index_user_connected_accounts_on_encrypted_access_token_iv  (encrypted_access_token_iv) UNIQUE
#  index_user_connected_accounts_on_user_id                    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class User::ConnectedAccount < ApplicationRecord
  serialize :auth, JSON

  # Associations
  belongs_to :user

  attr_encrypted :access_token, key: Base64.decode64(Rails.application.credentials.access_token_encryption_key)
  attr_encrypted :access_token_secret, key: Base64.decode64(Rails.application.credentials.access_token_encryption_key), allow_empty_value: true

  # Helper scopes for each provider
  Devise.omniauth_configs.each do |provider, _|
    scope provider, ->{ where(provider: provider) }
  end

  # Look up from Omniauth auth hash
  def self.for_auth(auth)
    where(provider: auth.provider, uid: auth.uid).first
  end

  def token
    if expires_at? && expires_at <= Time.zone.now
      new_token = current_token.refresh!
      update(
        access_token: new_token.token,
        refresh_token: new_token.refresh_token,
        expires_at: Time.at(new_token.expires_at)
      )
    end

    access_token
  end

  # Safely handles empty strings before attempting encryption
  def access_token_secret=(value)
    super(value.blank? ? nil : value)
  end

  private

    def current_token
      OAuth2::AccessToken.new(
        strategy.client,
        access_token,
        refresh_token: refresh_token
      )
    end

    def strategy
      provider_config = Jumpstart::Omniauth.enabled_providers[provider.to_sym]
      OmniAuth::Strategies.const_get(provider.classify).new(
        nil,
        provider_config[:public_key], # client id
        provider_config[:private_key], # client secret
      )
    end
end
