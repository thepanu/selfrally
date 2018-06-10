class CreateRibbons < ActiveRecord::Migration[5.1]
  def change
    create_table :ribbons do |t|
      t.string :name
      t.string :bronze_url
      t.string :silver_url
      t.string :gold_url

      t.timestamps
    end
  end
end
