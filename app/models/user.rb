class User < ApplicationRecord
  include ActionText::Attachable

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, andle :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :invitable, :masqueradable,
         :omniauthable

  include UserAgreements, UserTeams

  has_person_name

  # ActiveStorage Associations
  has_one_attached :avatar

  # Associations
  has_many :connected_accounts, dependent: :destroy

  # We don't need users to confirm their email address on create,
  # just when they change it
  before_create :skip_confirmation!

  # Validations
  validates :name, presence: true

  def to_trix_content_attachment_partial_path
    to_partial_path
  end
end
