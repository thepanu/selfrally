# Sidebar general menu generation helpers
module HeaderMenuHelper
  require 'application_helper'

  def header_items # rubocop:disable Metrics/MethodLength
    [
      {
        url: main_app.new_game_path,
        title: 'Add a game report',
        role: :user
      },
      {
        url: main_app.user_path(current_user),
        title: 'Profile',
        role: :user
      },
      {
        url: main_app.thredded_path,
        title: 'Forum',
        role: :user
      }
    ]
  end

  def header_helper(tag_info)
    html = ''
    header_items.each do |item|
      if logged_in?(item[:role])
        html << menu_link_builder(tag_info, { url: item[:url], title: item[:title] }, method: nil, rel: nil)
      end
    end
    html.html_safe
  end
end
