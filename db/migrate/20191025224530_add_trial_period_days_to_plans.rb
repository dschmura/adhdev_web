class AddTrialPeriodDaysToPlans < ActiveRecord::Migration[6.0]
  def self.up
    add_column :plans, :trial_period_days, :integer
    change_column_default :plans, :trial_period_days, 0

    Plan.reset_column_information

    Plan.create(
      name: "Free",
      interval: :month,
      trial_period_days: 0,
      details: {
        jumpstart_id: :free
      }
    )
  end

  def self.down
    remove_column :plans, :trial_period_days
  end
end
