class AdminController < ApplicationController
  access [:all, :user] => [], admin: :all
  def users
    @users = User.all
    render 'admin/users'
  end

  def edit_user
    @managed_user = User.find(params[:id])
  end
end
