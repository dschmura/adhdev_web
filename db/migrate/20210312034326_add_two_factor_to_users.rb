class AddTwoFactorToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :otp_required_for_login, :boolean
    add_column :users, :otp_secret, :string
    add_column :users, :last_otp_timestep, :integer
  end
end
