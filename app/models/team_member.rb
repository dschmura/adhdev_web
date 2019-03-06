class TeamMember < ApplicationRecord
  belongs_to :team
  belongs_to :user

  # Add team roles to this line
  ROLES = [:admin, :whatever]

  # Store the roles in the roles json column and cast to booleans
  store_accessor :roles, *ROLES
  ROLES.each{ |role| attribute role, :boolean }
end
