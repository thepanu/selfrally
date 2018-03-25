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
    #    self.previous_rating ||= fetch_previous_rating if user_id.present?
  end

  def update_ratings_pre(opponents_rating)
    update_attributes(
      expected_score: user.expected_score_against(opponents_rating),
      previous_rating: user.current_rating
    )
  end

  def update_ratings_post(opponents_rating)
    if game.provisional
      update_attributes(ratings_delta: 0, new_rating: DEFAULT_RATING)
    else
      update_ratings_with_score(opponents_rating)
    end
  end

  def update_ratings_with_score(opponents_rating)
    update_attributes(
      rating_delta: user.delta(winner && 1 || 0, opponents_rating),
      new_rating: user.new_rating(winner && 1 || 0, opponents_rating)
    )
  end
end
