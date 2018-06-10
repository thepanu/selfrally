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

  # :reek:DuplicateMethodCall <-- This is to overcome points going over the gold level upper limit
  def raise_class
    return bclass_to_s(bclass) unless pnts > BADGE_CLASS_CRITERIA[bclass][:upper]
    if new_class?
      bclass_to_s(bclass + 1)
    else
      bclass_to_s(bclass)
    end
  end

  private

  def new_class?
    criteria = BADGE_CLASS_CRITERIA[bclass + 1]
    pnts >= criteria[:lower] && pnts <= criteria[:upper]
  end

  def bclass
    UserRibbon.badgeclasses[badgeclass]
  end

  # :reek:UtilityFunction
  def bclass_to_s(index)
    UserRibbon.badgeclasses.key(index)
  end

  def pnts
    points + 1
  end
end
