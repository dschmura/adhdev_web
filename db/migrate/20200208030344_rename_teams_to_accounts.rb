class RenameTeamsToAccounts < ActiveRecord::Migration[6.0]
  def change
    if table_exists? :teams
      safety_assured do
        rename_column :team_members, :team_id, :account_id
        rename_column :team_invitations, :team_id, :account_id

        # TODO: Rename any team_id columns for your models here

        rename_table :teams, :accounts
        rename_table :team_members, :account_users
        rename_table :team_invitations, :account_invitations
      end
    end
  end
end
