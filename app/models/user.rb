class User < ApplicationRecord
  include Pay::Billable

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, andle :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :invitable, :masqueradable,
         :omniauthable

  has_person_name

  # ActiveStorage Associations
  has_one_attached :avatar

  # Associations
  has_many :connected_accounts, dependent: :destroy
  has_many :team_members
  has_many :teams, through: :team_members

  # We don't need users to confirm their email address on create,
  # just when they change it
  before_create :skip_confirmation!

  after_create :create_personal_team
  after_invitation_accepted :create_personal_team


  # Accept the terms of service on registration
  attribute :terms_of_service
  before_validation :accept_terms, on: [:create, :invitation_accepted]
  before_validation :accept_privacy, on: [:create, :invitation_accepted]
  validates :terms_of_service, acceptance: true, on: [:create, :invitation_accepted]

  validates :name, presence: true

  private

  def accept_terms
    self.accepted_terms_at = Time.zone.now
  end

  def accept_privacy
    self.accepted_privacy_at = Time.zone.now
  end

  def create_personal_team
    return unless name.present?
    team = Team.new(name: name)
    team.team_members.new(user: self, admin: true)
    team.save!
  end
end
