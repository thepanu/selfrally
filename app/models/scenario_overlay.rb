# Join table between scenarios and overlays
class ScenarioOverlay < ApplicationRecord
  belongs_to :scenario
  belongs_to :overlay
end
