class Team < ApplicationRecord
  include Pay::Billable

  belongs_to :owner, class_name: "User"
  has_many :team_members, dependent: :destroy
  has_many :users, through: :team_members

  scope :personal, ->{ where(personal: true) }

  has_one_attached :avatar

  validates :name, presence: true

  def email
    team_members.includes(:user).order(created_at: :asc).first.user.email
  end

  def personal_team_for?(user)
    personal? && owner_id == user.id
  end
end
