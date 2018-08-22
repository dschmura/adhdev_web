class User < ApplicationRecord
  include Pay::Billable
  extend Jumpstart::User::Omniauthable

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, andle :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :invitable, :masqueradable,
         :omniauthable

  # ActiveStorage Associations
  has_one_attached :avatar

  # Associations
  has_many :connected_accounts, dependent: :destroy
end
