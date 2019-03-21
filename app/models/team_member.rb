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
    define_method(:"#{role}?") { role == true }
  end
end
