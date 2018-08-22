class User::ConnectedAccount < ApplicationRecord
  extend Jumpstart::ConnectedAccount::Omniauthable

  # Associations
  belongs_to :user

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
