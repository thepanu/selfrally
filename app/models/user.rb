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

  # :reek:DuplicateMethodCall
  def fetch_previous_rating(date)
    # return 1500 if players_previous_plays(date).first.nil?
    players_previous_plays(date).first.new_rating unless players_previous_plays(date).empty?
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

  def players_previous_plays(date)
    # byebug
    GamePlayer.joins(:game).where(
      'games.date < ? AND game_players.user_id = ?',
      date, id
    ).order('games.date desc')
  end
end
