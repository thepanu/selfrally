# Join table between scenarios and rules
class ScenarioRule < ApplicationRecord
  belongs_to :scenario
  belongs_to :rule
end
