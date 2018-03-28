# Join model between scenarios and counters
class ScenarioCounter < ApplicationRecord
  belongs_to  :scenario
  belongs_to  :force
  belongs_to  :counter
end
