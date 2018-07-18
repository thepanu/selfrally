# User model to be used when no logged in active user
class GuestUser < User
  def initialize(_whydoineedthis)
    @first_name = 'Guest'
    @last_name = 'User'
    @email = 'guest@example.com'
    @roles = [:guest]
  end

  #  private

  attr_reader :first_name, :last_name, :email, :roles
end
