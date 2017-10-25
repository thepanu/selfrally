class Publication < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :publisher
  has_many :scenario_publications
  has_many :scenarios, :through => :scenario_publications
end
