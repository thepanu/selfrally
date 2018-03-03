class Game < ApplicationRecord
  enum status: {
    ongoing: 0,
    finished: 1,
    locked: 2
  }
  has_many :game_players, dependent: :destroy, inverse_of: :game
  belongs_to :scenario
  
  accepts_nested_attributes_for :game_players, allow_destroy: true
end
