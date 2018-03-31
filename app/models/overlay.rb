# Overlay model
class Overlay < ApplicationRecord
  has_many :scenario_overlays
  has_many :scenarios, through: :scenario_overlays
end
