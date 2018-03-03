class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.date :date
      t.integer :scenario_id
      t.integer :gamingtime
      t.float :turnsplayed
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
