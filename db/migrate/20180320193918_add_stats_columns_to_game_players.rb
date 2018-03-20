class AddStatsColumnsToGamePlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :game_players, :snake_eyes, :integer
    add_column :game_players, :boxcars, :integer
    add_column :game_players, :beers, :integer
    add_column :game_players, :rating, :decimal
  end
end
