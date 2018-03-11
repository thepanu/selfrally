# Scenarios forces
class ScenarioForce < ApplicationRecord
  belongs_to :scenario
  belongs_to :force
end
