class AddRatingColumnsToGamePlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :game_players, :previous_rating, :decimal
    add_column :game_players, :rating_delta, :decimal
    add_column :game_players, :new_rating, :decimal
  end
end
