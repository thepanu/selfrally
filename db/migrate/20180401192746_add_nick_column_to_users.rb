class AddNickColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nick, :string
  end
  DbTextSearch::CaseInsensitive.add_index(
    connection, Thredded.user_class.table_name, Thredded.user_name_column, unique: true)

end
