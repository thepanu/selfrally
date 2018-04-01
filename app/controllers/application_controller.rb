# Application controller TODO
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  include CurrentUserConcern

  def check_for_guest_user
    return unless current_user.has_roles?(:guest)
    flash.alert = 'You must be logged in to access forums!'
    redirect_to main_app.new_user_session_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name roles])
  end
end
