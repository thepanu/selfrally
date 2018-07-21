# Join table between users and ribbons
class UserRibbon < ApplicationRecord
  enum badgeclass: {
    nq: 0,
    bronze: 1,
    silver: 2,
    gold: 3
  }
  belongs_to :user
  belongs_to :ribbon
end
