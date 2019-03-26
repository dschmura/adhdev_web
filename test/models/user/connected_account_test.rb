# == Schema Information
#
# Table name: user_connected_accounts
#
#  id            :bigint(8)        not null, primary key
#  access_token  :string
#  auth          :string
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

require 'test_helper'

class User::ConnectedAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
