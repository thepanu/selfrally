class CreateScenarioPublications < ActiveRecord::Migration[5.1]
  def change
    create_table :scenario_publications do |t|
      t.integer :scenario_id
      t.integer :publication_id
      t.text    :code
      t.timestamps
    end
  end
end
