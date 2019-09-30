module UserTeams
  extend ActiveSupport::Concern

  included do
    has_many :team_members
    has_many :teams, through: :team_members, dependent: :destroy
    has_one :personal_team, ->{ where(personal: true) }, class_name: "Team", foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy

    # Regular users should get their team created immediately
    after_create :create_personal_team
    after_update :update_personal_team
  end

  def create_personal_team
    # Invited users don't have a name immediately, so we will run this method twice for them
    # once on create where no name is present and again on accepting the invitation
    return unless name.present?
    return if personal_team.present?

    team = build_personal_team name: name, personal: true
    team.team_members.new(user: self, admin: true)
    team.save!
    team
  end

  def update_personal_team
    if first_name_previously_changed? || last_name_previously_changed?
      # Accepting an invitation calls this when the user's name is updated
      create_personal_team if personal_team.nil?

      # Sync the personal team name with the user's name
      personal_team.update(name: name)
    end
  end
end
