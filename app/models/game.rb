class Game < ApplicationRecord
  enum status: {
    editable: 0,
    locked: 1
  }
  has_many :game_players
  belongs_to :scenario
end
