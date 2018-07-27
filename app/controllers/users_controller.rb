# User controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy games]

  def games
    @games = @user.games.includes(:scenario).order(date: :desc).page(params[:page]).per(15)
  end

  def find
    users = User.where.not(id: params[:exclude]).search(params[:search])
    respond_to do |format|
      format.json { render json: users.map { |user| { id: user.id, full_name: user.full_name } } }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
