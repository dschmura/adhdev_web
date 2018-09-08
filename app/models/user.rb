class User < ApplicationRecord
  include Pay::Billable
  extend Jumpstart::User::Omniauthable

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

  validates :name, presence: true

  # We don't need users to confirm their email address on create,
  # just when they change it
  before_create :skip_confirmation!

  attribute :terms_of_service
  validates :terms_of_service, acceptance: true, on: :create

  before_create { self.accepted_terms_at   = Time.zone.now }
  before_create { self.accepted_privacy_at = Time.zone.now }
end
