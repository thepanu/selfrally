# Rule model
class Rule < ApplicationRecord
  has_many :scenario_rules
  has_many :scenarios, through: :scenario_rules
  #  has_and_belongs_to_many :ribbons
  has_many :ribbons_rules
  has_many :ribbons, through: :ribbons_rules
  validates :name, presence: true
end
