class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :subject
      t.text :body
      t.integer :user_id
      t.references :commentable, polymorphic: true, index: true
      t.integer :parent_id

      t.timestamps
    end

  end
end
