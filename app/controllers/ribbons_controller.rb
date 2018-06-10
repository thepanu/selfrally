# Controller to show and handle ribbons
class RibbonsController < ApplicationController
  def index
    @ribbons = Ribbon.all
  end
end
