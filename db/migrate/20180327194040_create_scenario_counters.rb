class CreateScenarioCounters < ActiveRecord::Migration[5.1]
  def change
    create_table :scenario_counters do |t|
      t.integer :scenario_id
      t.integer :force_id
      t.integer :counter_id

      t.timestamps
    end
  end
end
