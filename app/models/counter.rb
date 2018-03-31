# Counter model to hold different kinds of counters in the game
class Counter < ApplicationRecord
  has_many :scenario_counters
  has_many :scenarios, through: :scenario_counters

  def to_s
    "#{name} #{counter_type}"
  end
end
