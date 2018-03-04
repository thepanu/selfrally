class Publisher < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :publications
  has_many :scenarios, through: :publications
  has_many :games, through: :scenarios
end
