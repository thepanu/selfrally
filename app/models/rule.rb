# Rule model
class Rule < ApplicationRecord
  has_many :scenario_rules
  has_many :scenarios, through: :scenario_rules
end
