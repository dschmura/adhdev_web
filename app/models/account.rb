# == Schema Information
#
# Table name: accounts
#
#  id                 :bigint(8)        not null, primary key
#  card_exp_month     :string
#  card_exp_year      :string
#  card_last4         :string
#  card_type          :string
#  extra_billing_info :text
#  name               :string
#  personal           :boolean          default(FALSE)
#  processor          :string
#  trial_ends_at      :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  owner_id           :bigint(8)
#  processor_id       :string
#
# Indexes
#
#  index_accounts_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#

class Account < ApplicationRecord
  include Pay::Billable

  RESERVED_DOMAINS = [Jumpstart.config.domain]
  RESERVED_SUBDOMAINS = %w[app help support]

  belongs_to :owner, class_name: "User"
  has_many :account_invitations, dependent: :destroy
  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users

  has_one_attached :logo

  scope :personal, -> { where(personal: true) }
  scope :impersonal, -> { where(personal: false) }

  has_one_attached :avatar

  validates :name, presence: true
  validates :domain, exclusion: {in: RESERVED_DOMAINS, message: "%{value} is reserved."}
  validates :subdomain, exclusion: {in: RESERVED_SUBDOMAINS, message: "%{value} is reserved."}, format: {with: /\A[a-zA-Z0-9]+[a-zA-Z0-9\-_]*[a-zA-Z0-9]+\Z/, message: "must be at least 2 characters and alphanumeric", allow_blank: true}

  def email
    account_users.includes(:user).order(created_at: :asc).first.user.email
  end

  def personal_account_for?(user)
    personal? && owner_id == user.id
  end

  # Uncomment this to add generic trials (without a card or plan)
  #
  # before_create do
  #   self.trial_ends_at = 14.days.from_now
  # end
end
