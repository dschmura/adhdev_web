# == Schema Information
#
# Table name: user_connected_accounts
#
#  id            :bigint(8)        not null, primary key
#  access_token  :string
#  auth          :text
#  expires_at    :datetime
#  provider      :string
#  refresh_token :string
#  uid           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint(8)
#
# Indexes
#
#  index_user_connected_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class User::ConnectedAccount < ApplicationRecord
  serialize :auth, JSON

  # Associations
  belongs_to :user

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

  def current_token
    OAuth2::AccessToken.new(
      strategy.client,
      access_token,
      refresh_token: refresh_token
    )
  end

  def strategy
    OmniAuth::Strategies.const_get(provider.classify).new(
      nil,
      Rails.application.secrets.send("#{provider}_client_id"),
      Rails.application.secrets.send("#{provider}_client_secret")
    )
  end
end
