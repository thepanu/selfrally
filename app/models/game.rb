# Game model to handle game reports
class Game < ApplicationRecord
  enum status: {
    ongoing: 0,
    finished: 1,
    locked: 2
  }
  has_many :game_players, dependent: :destroy, inverse_of: :game
  has_many :users, through: :game_players
  belongs_to :scenario
  has_many :ribbons, through: :scenario

  validates :scenario_id, :date, :status, presence: true
  accepts_nested_attributes_for :game_players, allow_destroy: true

  def no_players?
    game_players.empty?
  end

  def provisional?
    game_players.each do |play|
      return true if play.user.previous_plays(date).size < PROVISIONAL_LIMIT
    end
    false
  end

  def opponent_for(player)
    game_players.where.not(user_id: player.user_id).first.user
  end

  def player_by_initiative(initiative)
    game_players.where(
      force_id: force_by_initiative(initiative).id
    ).first
  end

  def force_by_initiative(initiative)
    scenario.scenario_forces.where(initiative: initiative).first.force
  end
end
