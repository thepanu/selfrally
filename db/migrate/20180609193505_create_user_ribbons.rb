class CreateUserRibbons < ActiveRecord::Migration[5.1]
  def change
    create_table :user_ribbons do |t|
      t.integer :user_id
      t.integer :ribbon_id
      t.integer :badgeclass, :default => 0
      t.integer :points, :default => 0

      t.timestamps
    end
  end
end
