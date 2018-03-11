# Relation between scenario and publication(s) it belongs to
class ScenarioPublication < ApplicationRecord
  belongs_to :scenario
  belongs_to :publication
end
