class User < ApplicationRecord
  include Pay::Billable
  extend Jumpstart::User::Omniauthable

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, andle :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :invitable, :masqueradable,
         :omniauthable

  has_one_attached :avatar

  # We don't need users to confirm their email address on create,
  # just when they change it
  before_create :skip_confirmation!
end
