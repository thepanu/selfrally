class Publisher < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :publications
end
