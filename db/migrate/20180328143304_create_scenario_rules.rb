class CreateScenarioRules < ActiveRecord::Migration[5.1]
  def change
    create_table :scenario_rules do |t|
      t.integer :scenario_id
      t.integer :rule_id

      t.timestamps
    end
  end
end
