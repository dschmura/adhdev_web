class Team < ApplicationRecord
  include Pay::Billable

  has_many :team_members
  has_many :users, through: :team_members

  scope :personal, ->{ where(personal: true) }

  has_one_attached :avatar

  validates :name, presence: true

  def email
    team_members.includes(:user).order(created_at: :asc).first.user.email
  end
end
