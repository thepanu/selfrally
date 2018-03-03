class GamePlayer < ApplicationRecord
  enum result: {
    draw: 0,
    loser: 1,
    winner: 2
  }
  belongs_to :game, inverse_of: :game_players
  belongs_to :user, optional: true
  belongs_to :force

end
