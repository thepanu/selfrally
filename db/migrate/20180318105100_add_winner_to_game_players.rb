class AddWinnerToGamePlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :game_players, :winner, :boolean
  end
end
