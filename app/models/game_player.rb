class GamePlayer < ApplicationRecord
  enum status: {
    loser: 0,
    winner: 1
  }
  belongs_to :game
  belongs_to :user
  has_one :force
  
end
