class AddColumnToGamePlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :game_players, :provisional, :boolean, default: false
  end
end
