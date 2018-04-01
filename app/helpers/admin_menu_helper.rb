# Admin menu generation helpers
module AdminMenuHelper
  require 'application_helper'

  def admin_items
    [
      {
        url: main_app.admin_users_path,
        title: 'Manage users'
      }
    ]
  end

  def sidebar_admin_helper(tag_info)
    html = sidebar_admin_title(tag_info[:tag_type], tag_info[:tag_style])
    admin_items.each do |item|
      html << menu_link_builder(tag_info, { url: item[:url], title: item[:title] }, method: nil, rel: nil)
    end
    html.html_safe
  end

  def sidebar_admin_title(tag_type, tag_style)
    format(
      '<%<tag>s class="%<tag_style>s"><h5>Admin</h5></%<tag>',
      tag: tag_type,
      tag_style: tag_style
    )
  end
end
