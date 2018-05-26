class CreateUserRanks < ActiveRecord::Migration[5.1]
  def change
    create_table :user_ranks do |t|
      t.integer :user_id
      t.integer :rank_id
      t.date :promotion_date
      t.timestamps
    end
  end
end
