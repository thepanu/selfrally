# Game model to handle game reports
class Game < ApplicationRecord
  enum status: {
    ongoing: 0,
    finished: 1,
    locked: 2
  }
  has_many :game_players, dependent: :destroy, inverse_of: :game
  belongs_to :scenario

  validates :scenario_id, :date, :status, presence: true
  accepts_nested_attributes_for :game_players, allow_destroy: true

  def no_players?
    game_players.empty?
  end
end
