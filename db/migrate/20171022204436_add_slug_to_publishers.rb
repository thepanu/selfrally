class AddSlugToPublishers < ActiveRecord::Migration[5.1]
  def change
    add_column :publishers, :slug, :text
  end
end
