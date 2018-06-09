# User model
# :reek:TooManyMethods
class User < ApplicationRecord
  has_many :game_players
  has_many :games, through: :game_players
  has_many :user_ranks
  has_many :ranks, through: :user_ranks

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

  validates :first_name, :last_name, :email, :nick, presence: true
  validates :email, :nick, uniqueness: true

  def full_name
    format(
      '%<firstname>s %<lastname>s',
      firstname: first_name,
      lastname: last_name || ''
    )
  end

  def current_rank
    user_ranks.order(promotion_date: :desc).first.rank
  end

  def rank_on_date(date)
    user_ranks.where('promotion_date <= ?', date).order(promotion_date: :desc).first.rank
  end

  def promote?
    Rank.where('ranks.limit <= ?', games.count).order(limit: :desc).first != current_rank
  end

  def promote_on_date?(date)
    Rank.where(
      'ranks.limit <= ?', games.where('date <= ? AND status = ?', date, 1).count
    ).order(limit: :desc).first != rank_on_date(date)
  end

  def check_for_promotion(date)
    return nil unless promote_on_date?(date)
    user_ranks.create(rank_id: next_rank.id, promotion_date: date)
  end

  def next_rank
    Rank.where('ranks.limit > ?', current_rank.limit).order(limit: :asc).first
  end

  def elo
    EloRating.new(fetch_previous_rating(Date.today))
  end

  def current_rating
    elo.current_rating
  end

  def rating_on_date(date)
    EloRating.new(fetch_previous_rating(date)).current_rating
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
    return DEFAULT_RATING if prev_plays.empty?
    prev_plays.first.new_rating
  end

  def previous_plays(date)
    GamePlayer.joins(:game).where(
      'games.date < ? AND game_players.user_id = ?',
      date, id
    ).order('games.date desc')
  end
end
