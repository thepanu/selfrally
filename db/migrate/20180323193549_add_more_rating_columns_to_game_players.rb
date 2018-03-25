class AddMoreRatingColumnsToGamePlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :game_players, :expected_score, :decimal
    add_column :games, :provisional, :boolean
  end
end
