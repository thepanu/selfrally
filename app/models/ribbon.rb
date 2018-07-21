# Model for ribbons awarded based on rules used
class Ribbon < ApplicationRecord
  # has_and_belongs_to_many :rules
  # has_many :rules, through: :ribbon_rules
  has_many :ribbons_rules
  has_many :rules, through: :ribbons_rules
  has_many :scenarios, through: :rules
  has_many :games, through: :scenarios

  has_many :user_ribbons
  has_many :users, through: :user_ribbons
  validates :name, presence: true

  def assigned_ribbons(badgeclass)
    user_ribbons.where(badgeclass: badgeclass).includes(:user)
  end
end
