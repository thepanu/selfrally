class CreateForces < ActiveRecord::Migration[5.1]
  def change
    create_table :forces do |t|
      t.text :name

      t.timestamps
    end
  end
end
