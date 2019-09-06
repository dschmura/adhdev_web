# == Schema Information
#
# Table name: team_members
#
#  id         :bigint(8)        not null, primary key
#  roles      :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_team_members_on_team_id  (team_id)
#  index_team_members_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#  fk_rails_...  (user_id => users.id)
#

class TeamMember < ApplicationRecord
  belongs_to :team
  belongs_to :user

  # Add team roles to this line
  ROLES = [:admin]

  # Store the roles in the roles json column and cast to booleans
  store_accessor :roles, *ROLES

  # Cast roles to/from booleans
  ROLES.each do |role|
    define_method(:"#{role}=") { |value| super ActiveRecord::Type::Boolean.new.deserialize(value) }
    define_method(:"#{role}")  { ActiveRecord::Type::Boolean.new.deserialize super() }
    define_method(:"#{role}?") { send(role) }
  end
end
