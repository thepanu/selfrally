# Prepare guest user if no logged in user
module CurrentUserConcern
  extend ActiveSupport::Concern

  def current_user
    super || GuestUser.new
  end
end
