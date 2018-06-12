# User controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy games]

  def games
    @games = @user.games.order(date: :desc).page(params[:page]).per(15)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
