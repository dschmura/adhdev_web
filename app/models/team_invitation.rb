class TeamInvitation < ApplicationRecord
  belongs_to :team
  belongs_to :invited_by, class_name: "User", optional: true
  has_secure_token

  validates :name, :email, presence: true
  validates :email, uniqueness: { scope: :team_id, message: "has already been invited" }

  # Store the roles in the roles json column and cast to booleans
  store_accessor :roles, *TeamMember::ROLES

  # Cast roles to/from booleans
  TeamMember::ROLES.each do |role|
    define_method(:"#{role}=") { |value| super ActiveRecord::Type::Boolean.new.cast(value) }
    define_method(:"#{role}?") { send(role) }
  end

  def save_and_send_invite
    if save
      TeamInvitationsMailer.with(team_invitation: self).invite.deliver_later
    end
  end

  def accept!(user)
    team_member = team.team_members.new(user: user, roles: roles)
    if team_member.valid?
      ApplicationRecord.transaction do
        team_member.save
        destroy
      end
      team_member
    else
      errors.add(:base, team_member.errors.full_messages.first)
      nil
    end
  end

  def reject!
    destroy
  end

  def to_param
    token
  end
end
