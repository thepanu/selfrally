# Force model (a nation or army)
class Force < ApplicationRecord
  has_many :scenario_forces
  has_many :scenarios, through: :scenario_forces
  has_many :scenario_counters
  has_many :counters, through: :scenario_counters

  def scenarios_counters(scenario)
    ids = ScenarioCounter.where(scenario_id: scenario, force_id: id).pluck(:counter_id)
    Counter.where(id: ids)
  end
end
