# Sidebar general menu generation helpers
module SidebarMenuHelper
  require 'application_helper'

  def sidebar_items # rubocop:disable Metrics/MethodLength
    [
      # {
      #   url: "#",
      #   title: "Player ratings"
      # },
      {
        url: main_app.games_path,
        title: 'Gaming results'
      },
      {
        url: main_app.publishers_path,
        title: 'Scenario publishers'
      },
      {
        url: main_app.publications_path,
        title: 'Scenario publications'
      },
      {
        url: main_app.scenarios_path,
        title: 'Scenario index'
      },
      {
        url: main_app.ribbons_path,
        title: 'Special Service Ribbons'
      }
    ]
  end

  def sidebar_helper(tag_info)
    html = ''
    sidebar_items.each do |item|
      html << menu_link_builder(tag_info, { url: item[:url], title: item[:title] }, method: nil, rel: nil)
    end
    html.html_safe
  end
end
