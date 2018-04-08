# Join model between users and ranks
class UserRank < ApplicationRecord
  belongs_to :user
  belongs_to :rank
end
