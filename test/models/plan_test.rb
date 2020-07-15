# == Schema Information
#
# Table name: plans
#
#  id                :bigint           not null, primary key
#  amount            :integer          default(0), not null
#  details           :jsonb            not null
#  interval          :string
#  name              :string
#  trial_period_days :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require "test_helper"

class PlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
