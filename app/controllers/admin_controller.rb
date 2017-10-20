class AdminController < ApplicationController
  access [:all, :user] => [], admin: :all
  def users
    @users = User.all
  end
end
