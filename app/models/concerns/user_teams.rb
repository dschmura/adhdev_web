module UserTeams
  extend ActiveSupport::Concern

  included do
    has_many :team_members
    has_many :teams, through: :team_members

    # Regular users should get their team created immediately
    after_create :create_personal_team
    after_update :update_personal_team

    # Invited users should have their team created after accepting the invitation
    after_invitation_accepted :create_personal_team
  end

  def create_personal_team
    # Invited users don't have a name immediately, so we will run this method twice for them
    # once on create where no name is present and again on accepting the invitation
    return unless name.present?

    team = Team.new name: name, personal: true
    team.team_members.new(user: self, admin: true)
    team.save!
  end

  def update_personal_team
    if first_name_previously_changed? || last_name_previously_changed?
      teams.personal.first.update(name: name)
    end
  end
end
