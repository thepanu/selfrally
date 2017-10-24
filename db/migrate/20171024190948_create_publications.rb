class CreatePublications < ActiveRecord::Migration[5.1]
  def change
    create_table :publications do |t|
      t.text :name
      t.integer :publishing_year
      t.text :slug
      t.references :publisher, foreign_key: true

      t.timestamps
    end
  end
end
