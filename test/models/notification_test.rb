# == Schema Information
#
# Table name: notifications
#
#  id             :bigint           not null, primary key
#  interacted_at  :datetime
#  params         :jsonb
#  read_at        :datetime
#  recipient_type :string           not null
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :bigint           not null
#  recipient_id   :bigint           not null
#
# Indexes
#
#  index_notifications_on_account_id                       (account_id)
#  index_notifications_on_recipient_type_and_recipient_id  (recipient_type,recipient_id)
#
require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
