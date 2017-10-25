class CreateScenarios < ActiveRecord::Migration[5.1]
  def change
    create_table :scenarios do |t|
      t.text :name
      t.date :scenario_date
      t.float :gameturns
      t.integer :location_id
      t.text :slug

      t.timestamps
    end
  end
end
