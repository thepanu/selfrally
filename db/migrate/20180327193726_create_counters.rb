class CreateCounters < ActiveRecord::Migration[5.1]
  def change
    create_table :counters do |t|
      t.string :name
      t.string :counter_type

      t.timestamps
    end
  end
end
