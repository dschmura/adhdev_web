class RenameTeamsToAccounts < ActiveRecord::Migration[6.0]
  def change
    if table_exists? :teams
      safety_assured do
        rename_table :teams, :accounts
        rename_table :team_members, :account_users
        rename_table :team_invitations, :account_invitations
        rename_column :team_members, :team_id, :account_id
        rename_column :team_invitations, :team_id, :account_id
      end
    end
  end
end
