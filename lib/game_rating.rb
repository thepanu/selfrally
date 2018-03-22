# The class to calculate ratings new ratings for players after the game and expected result prior to game
# Takes in players as array of hashes and results as array.
class GameRating
  DEFAULT_RATING = 1500
  ELO_K = 32
  PROVISIONAL_LIMIT = 10

  def initialize(players)
    raise ArgumentError, 'Only two players allowed!' if players.size > 2
    @players = players
    @players.each do |player|
      player[:previous_rating] ||= DEFAULT_RATING
    end
    update_expected
  end

  def provisional?
    @players.each do |player|
      return true if player[:games] <= 10
    end
    false
  end

  def game_ended?
    @players.inject(0) { |sum, player| sum + player[:score] } != 0
  end

  def update_expected
    @players.each.with_index do |player, index|
      player[:expected_score] = expected(player[:previous_rating], @players[(index == 1 ? 0 : 1)][:previous_rating])
    end
  end

  # :reek:DuplicateMethodCall :reek:UtilityFunction
  def expected(rated_player, other_player)
    10**(rated_player / 400.0) / (10**(rated_player / 400.0) + 10**(other_player / 400.0))
  end

  # :reek:FeatureEnvy
  def result
    if game_ended?
      @players.each do |player|
        player[:rating_delta] = (ELO_K * (player[:score] - player[:expected_score])).round(1)
        player[:new_rating] = (player[:previous_rating] + player[:rating_delta]).round(1)
      end
    end
    @players
  end
end
