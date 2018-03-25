# Calculations class holds formulas which don't belong to any other specific class
class Calculations
  def self.powerize(rating)
    10**rating.fdiv(400)
  end
end
