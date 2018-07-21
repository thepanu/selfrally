# Join model for ribbons and rules
class RibbonsRule < ApplicationRecord
  belongs_to :rule
  belongs_to :ribbon
end
