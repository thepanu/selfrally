# A participant in a game
class GamePlayer < ApplicationRecord
  enum result: {
    loser: 0,
    winner: 1,
    draw: 2
  }
  belongs_to :game, inverse_of: :game_players
  belongs_to :user, optional: true
  belongs_to :force

  after_initialize :init

  def init
    self.result ||= 0
  end

  def for_rating
    {
      previous_rating: previous_rating,
      expected_score: nil,
      rating_delta: nil,
      new_rating: nil
    }
  end
end
