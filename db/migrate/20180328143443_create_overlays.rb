class CreateOverlays < ActiveRecord::Migration[5.1]
  def change
    create_table :overlays do |t|
      t.string :name

      t.timestamps
    end
  end
end
