# Model to handle various ranks awarded to players
class Rank < ApplicationRecord
  has_many   :user_ranks
  has_many   :users, through: :user_ranks
end
