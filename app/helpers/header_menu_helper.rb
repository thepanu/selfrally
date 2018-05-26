# Sidebar general menu generation helpers
module HeaderMenuHelper
  require 'application_helper'

  def header_items # rubocop:disable Metrics/MethodLength
    [
      {
        url: main_app.new_game_path,
        title: 'Add a game report'
      },
      {
        url: main_app.user_path(current_user),
        title: 'Profile'
      },
      {
        url: main_app.thredded_path,
        title: 'Forum'
      }
    ]
  end

  def header_helper(tag_info)
    return unless logged_in?(:user)
    html = ''
    header_items.each do |item|
      html << menu_link_builder(tag_info, { url: item[:url], title: item[:title] }, method: nil, rel: nil)
    end
    html.html_safe
  end
end
