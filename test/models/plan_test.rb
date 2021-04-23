# == Schema Information
#
# Table name: plans
#
#  id                :bigint           not null, primary key
#  amount            :integer          default(0), not null
#  details           :jsonb            not null
#  hidden            :boolean
#  interval          :string           not null
#  name              :string           not null
#  trial_period_days :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require "test_helper"

class PlanTest < ActiveSupport::TestCase
  test "find_interval_plan" do
    assert_equal annual, monthly.find_interval_plan
    assert_equal monthly, annual.find_interval_plan
  end

  test "monthly?" do
    assert monthly.monthly?
    refute annual.monthly?
  end

  test "annual?" do
    assert annual.annual?
    refute monthly.annual?
  end

  test "yearly?" do
    assert annual.yearly?
    refute monthly.yearly?
  end

  test "monthly_version" do
    assert_equal monthly, annual.monthly_version
  end

  test "yearly_version" do
    assert_equal annual, monthly.yearly_version
  end

  test "annual_version" do
    assert_equal annual, monthly.annual_version
  end

  private

  def monthly
    @monthly ||= plans(:personal)
  end

  def annual
    @annual ||= plans(:personal_annual)
  end
end
