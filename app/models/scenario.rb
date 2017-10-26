class Scenario < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :scenario_publications
  has_many :publications, :through => :scenario_publications
  has_many :games
end
