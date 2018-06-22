# Update ratings for games game_players before and after the report is finished
class UpdateRatings
  attr_reader :game

  def initialize(params)
    @game = params[:game]
  end

  def self.call(params)
    new(params).call
  end

  def call
    update_pre
    update_post if game.finished?
  end

  private

  #  :reek:DuplicateMethodCall
  def update_pre # rubocop:disable Metrics/AbcSize
    game.game_players.each do |play|
      play.update_attributes(
        expected_score: expected_score(play.user, opponent_for(play).user, game.date),
        previous_rating: play.user.rating_on_date(game.date),
        provisional: play.user.previous_plays(game.date).size < PROVISIONAL_LIMIT
      )
    end
  end

  def update_post
    game.game_players.each do |play|
      opponent = opponent_for(play)
      if opponent.provisional && !play.provisional
        play.update_attributes(rating_delta: 0, new_rating: play.previous_rating || DEFAULT_RATING)
      else
        update_ratings_with_score(play, opponent.previous_rating)
      end
    end
  end

  # :reek:DuplicateMethodCall :reek:UtilityFunction
  def update_ratings_with_score(play, opponents_rating)
    user = play.user
    play.update_attributes(
      rating_delta: user.delta(play.winner && 1 || 0, opponents_rating),
      new_rating: user.new_rating(play.winner && 1 || 0, opponents_rating)
    )
  end

  def opponent_for(play)
    game.game_players.where.not(user_id: play.user_id).first
  end

  # :reek:UtilityFunction
  def expected_score(user, opponent, date)
    EloRating.new(
      user.rating_on_date(date)
    ).expected_score_against(
      opponent.rating_on_date(date)
    )
  end
end
