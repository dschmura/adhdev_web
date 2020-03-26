# == Schema Information
#
# Table name: plans
#
#  id         :bigint(8)        not null, primary key
#  amount     :integer          default(0), not null
#  details    :jsonb            not null
#  interval   :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Plan < ApplicationRecord
  store_accessor :details, :features, :stripe_id, :braintree_id, :jumpstart_id
  attribute :features, :string, array: true

  validates :name, :amount, :interval, presence: true
  validates :interval, inclusion: %w[month year]
  validates :trial_period_days, numericality: {only_integer: true}

  scope :monthly, -> { without_free.where(interval: :month) }
  scope :yearly, -> { without_free.where(interval: :year) }
  scope :sorted, -> { order(amount: :asc) }
  scope :without_free, -> { where.not(details: {jumpstart_id: :free}) }

  def features
    Array.wrap(super)
  end

  # Find a plan with the same name in the opposite interval
  # This is useful when letting users upgrade to the yearly plan
  def find_interval_plan
    if interval == :month
      yearly.where(name: name).first
    else
      monthly.where(name: name).first
    end
  end

  def yearly_version
    return self if interval == "yearly"
    yearly.where(name: name).first
  end

  def monthly_version
    return self if interval == "monthly"
    monthly.where(name: name).first
  end

  def processor_id(processor)
    return if processor.nil?
    send("#{processor}_id")
  end
end
