class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.belongs_to :owner, foreign_key: { to_table: :users }
      t.boolean :personal, default: false

      t.timestamps
    end
  end
end
