class CreateScenarioOverlays < ActiveRecord::Migration[5.1]
  def change
    create_table :scenario_overlays do |t|
      t.integer :scenario_id
      t.integer :overlay_id

      t.timestamps
    end
  end
end
