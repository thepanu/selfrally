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

  #  def players_previous_plays
  #    #byebug
  #    GamePlayer.joins(:game).where(
  #      'games.date < ? AND game_players.user_id = ?',
  #      game.date, user_id
  #    ).order('games.date desc')
  #  end

  def init
    self.result ||= 0
    #    self.previous_rating ||= fetch_previous_rating if user_id.present?
  end

  #  def fetch_previous_rating
  #    byebug
  #    return 1500 if players_previous_plays.first.nil?
  #    players_previous_plays.first.new_rating
  #  end
  #
  #  def self.for_rating(player_id)
  #    byebug
  #    {
  #      id: id,
  #      previous_rating: fetch_previous_rating,
  #      score: (winner ? 1 : 0),
  #      games: players_previous_plays.size
  #    }
  #  end
end
