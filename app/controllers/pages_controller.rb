# Pages controller
class PagesController < ApplicationController
  def home
    @games = Game.all.order(date: :desc).includes(:scenario).limit(3)
  end
end
