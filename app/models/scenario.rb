class Scenario < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :scenario_publications
  has_many :publications, :through => :scenario_publications
  has_many :games
  has_many :scenario_forces
  has_many :forces, :through => :scenario_forces

  def belligerents
    self.forces.pluck(:name).join(" - ")    
  end
end
