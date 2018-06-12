# Pages controller
class PagesController < ApplicationController
  def home
    @games = Game.all.order(date: :desc).limit(3)
  end
end
