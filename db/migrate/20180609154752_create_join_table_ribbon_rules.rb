class CreateJoinTableRibbonRules < ActiveRecord::Migration[5.1]
  def change
    create_join_table :ribbons, :rules
  end
end
