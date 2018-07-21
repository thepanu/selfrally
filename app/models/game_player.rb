# A participant in a game
class GamePlayer < ApplicationRecord
  enum result: {
    loser: 0,
    winner: 1,
    draw: 2
  }
  belongs_to :game, inverse_of: :game_players
  has_one :scenario, through: :game
  belongs_to :user, optional: true
  belongs_to :force

  after_initialize :init

  def init
    self.result ||= 0
  end
end
