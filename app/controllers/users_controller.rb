# User controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  private

  def set_user
    @user = User.find(params[:id])
  end
end
