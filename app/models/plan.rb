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

class Plan < ApplicationRecord
  # Generates hash IDs with a friendly prefix so users can't guess hidden plan IDs on checkout
  # https://github.com/excid3/prefixed_ids
  has_prefix_id :plan

  store_accessor :details, :features, :stripe_id, :braintree_id, :paddle_id, :jumpstart_id, :fake_processor_id
  attribute :features, :string, array: true

  validates :name, :amount, :interval, presence: true
  validates :interval, inclusion: %w[month year]
  validates :trial_period_days, numericality: {only_integer: true}

  scope :monthly, -> { without_free.where(interval: :month) }
  scope :yearly, -> { without_free.where(interval: :year) }
  scope :sorted, -> { order(amount: :asc) }
  scope :without_free, -> { where.not("details @> ?", {fake_processor_id: :free}.to_json) }
  scope :hidden, -> { where(hidden: true) }
  scope :visible, -> { where(hidden: [nil, false]) }

  def features
    Array.wrap(super)
  end

  def monthly?
    interval == "month"
  end

  def annual?
    interval == "year"
  end
  alias_method :yearly?, :annual?

  # Find a plan with the same name in the opposite interval
  # This is useful when letting users upgrade to the yearly plan
  def find_interval_plan
    monthly? ? annual_version : monthly_version
  end

  def annual_version
    return self if annual?
    self.class.yearly.where(name: name).first
  end
  alias_method :yearly_version, :annual_version

  def monthly_version
    return self if monthly?
    self.class.monthly.where(name: name).first
  end

  def processor_id(processor)
    return if processor.nil?
    send("#{processor}_id")
  end
end
