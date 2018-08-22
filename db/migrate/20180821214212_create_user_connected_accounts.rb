class CreateUserConnectedAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_connected_accounts do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at
      t.string :auth
      t.string :uid

      t.timestamps
    end
  end
end
