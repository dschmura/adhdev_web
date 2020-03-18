# == Schema Information
#
# Table name: account_users
#
#  id         :bigint(8)        not null, primary key
#  roles      :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id    :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_account_users_on_account_id  (account_id)
#  index_account_users_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#

class AccountUser < ApplicationRecord
  belongs_to :account
  belongs_to :user

  validates :user_id, uniqueness: {scope: :account_id}

  # Add account roles to this line
  ROLES = [:admin, :member]

  # Store the roles in the roles json column and cast to booleans
  store_accessor :roles, *ROLES

  # Cast roles to/from booleans
  ROLES.each do |role|
    scope role, -> { where("roles @> ?", {role => true}.to_json) }

    define_method(:"#{role}=") { |value| super ActiveRecord::Type::Boolean.new.cast(value) }
    define_method(:"#{role}?") { send(role) }
  end

  def active_roles
    ROLES.select { |role| send(:"#{role}?") }.compact
  end
end
