class CreateGamePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :game_players do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :result
      t.integer :force_id

      t.timestamps
    end
  end
end
