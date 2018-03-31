# Join model betwwn maps and scenarios
class ScenarioMap < ApplicationRecord
  belongs_to :scenario
  belongs_to :map
end
