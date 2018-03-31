class CreateScenarioMaps < ActiveRecord::Migration[5.1]
  def change
    create_table :scenario_maps do |t|
      t.integer :scenario_id
      t.integer :map_id

      t.timestamps
    end
  end
end
