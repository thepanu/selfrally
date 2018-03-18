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
        url: games_path,
        title: 'Gaming results'
      },
      {
        url: publishers_path,
        title: 'Scenario publishers'
      },
      {
        url: publications_path,
        title: 'Scenario publications'
      },
      {
        url: scenarios_path,
        title: 'Scenario index'
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
