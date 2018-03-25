# User model
class User < ApplicationRecord
  ############################################################################################
  ## PeterGate Roles                                                                        ##
  ## The :user role is added by default and shouldn't be included in this list.             ##
  ## The :root_admin can access any page regardless of access settings. Use with caution!   ##
  ## The multiple option can be set to true if you need users to have multiple roles.       ##
  petergate(roles: %i[admin editor], multiple: false) ##
  ############################################################################################

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :first_name, :last_name, :email, :password, presence: true
  validates :email, uniqueness: true
  def full_name
    format(
      '%<firstname>s %<lastname>s',
      firstname: first_name,
      lastname: last_name || ''
    )
  end

  def elo
    EloRating.new(fetch_previous_rating(Date.today))
  end

  def current_rating
    elo.current_rating
  end

  def delta(score, opponents_rating)
    elo.delta(score, opponents_rating)
  end

  def new_rating(score, opponents_rating)
    elo.new_rating(score, opponents_rating)
  end

  def expected_score_against(opponents_rating)
    elo.expected_score_against(opponents_rating)
  end

  # :reek:FeatureEnvy
  def fetch_previous_rating(date)
    prev_plays = previous_plays(date)
    return nil if prev_plays.empty?
    prev_plays.first.new_rating
  end

  def for_rating(date, winner = 0)
    # byebug
    {
      user_id: id,
      previous_rating: fetch_previous_rating(date),
      score: winner,
      games: players_previous_plays(date).size
    }
  end

  def previous_plays(date)
    GamePlayer.joins(:game).where(
      'games.date < ? AND game_players.user_id = ?',
      date, id
    ).order('games.date desc')
  end
end
