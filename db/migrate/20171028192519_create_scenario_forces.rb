class CreateScenarioForces < ActiveRecord::Migration[5.1]
  def change
    create_table :scenario_forces do |t|
      t.integer :scenario_id
      t.integer :force_id
      t.integer :initiative

      t.timestamps
    end
  end
end
