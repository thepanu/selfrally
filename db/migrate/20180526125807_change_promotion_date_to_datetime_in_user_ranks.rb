class ChangePromotionDateToDatetimeInUserRanks < ActiveRecord::Migration[5.1]
  def change
    change_column :user_ranks, :promotion_date, :datetime
  end
end
