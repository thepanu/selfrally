class AddRanksTable < ActiveRecord::Migration[5.1]
  def change
    create_table :ranks do |t|
      t.integer :limit
      t.string  :name
      t.string  :img
      t.timestamps
    end
  end
end
