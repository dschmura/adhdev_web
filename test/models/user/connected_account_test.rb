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

require 'test_helper'

class User::ConnectedAccountTest < ActiveSupport::TestCase
  test "handles empty access token secrets" do
    assert_nothing_raised do
      User::ConnectedAccount.new(access_token_secret: "")
    end
  end
end
