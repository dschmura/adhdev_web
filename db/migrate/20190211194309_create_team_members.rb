class CreateTeamMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :team_members do |t|
      t.belongs_to :team, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.boolean :admin

      t.timestamps
    end
  end
end
