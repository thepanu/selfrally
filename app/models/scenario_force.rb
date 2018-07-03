# Scenarios forces
class ScenarioForce < ApplicationRecord
  belongs_to :scenario
  belongs_to :force

  after_initialize :init

  def init
    self.initiative ||= 0
  end
end
