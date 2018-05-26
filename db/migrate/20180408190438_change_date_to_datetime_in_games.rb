class ChangeDateToDatetimeInGames < ActiveRecord::Migration[5.1]
  def change
    change_column :games, :date, :datetime
  end
end
