# User model to be used when no logged in active user
class GuestUser < User
  def initialize
    @first_name = 'Guest' # guest_user_params[:first_name]
    @last_name = 'User' # guest_user_params[:last_name]
    @email = 'guest@example.com' # guest_user_params[:email]
    @roles = [:guest]
  end

  #  private

  attr_reader :first_name, :last_name, :email, :roles
end
