# Map model
class Map < ApplicationRecord
  has_many :scenario_maps
  has_many :scenarios, through: :scenario_maps
end
