# Calculations regarding EloRating of players (users)
class EloRating
  attr_reader :current_rating

  def initialize(current_rating)
    @current_rating = current_rating
  end

  def expected_score_against(opponents_rating)
    powerize / denominator(opponents_rating)
  end

  def delta(actual_score, opponents_rating)
    (ELO_K * (actual_score - expected_score_against(opponents_rating))).round(1)
  end

  def new_rating(actual_score, opponents_rating)
    current_rating + delta(actual_score, opponents_rating)
  end

  private

  def powerize(rating = current_rating)
    10**rating.fdiv(400)
  end

  def denominator(opponents_rating)
    powerize + powerize(opponents_rating)
  end
end
