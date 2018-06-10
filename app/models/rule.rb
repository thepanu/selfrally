# Rule model
class Rule < ApplicationRecord
  has_many :scenario_rules
  has_many :scenarios, through: :scenario_rules
  has_and_belongs_to_many :ribbons

  validates :name, presence: true
end
