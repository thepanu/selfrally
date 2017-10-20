module ApplicationHelper
  def login_helper tag_style="", link_style=""
    if !current_user.is_a?(GuestUser)
      "<li class=\"#{tag_style}\">#{link_to "Logout", destroy_user_session_path, method: :delete, class: link_style}</li>".html_safe
    else
      "<li class=\"#{tag_style}\">#{link_to "Login", new_user_session_path, class: link_style}</li>
      <li class=\"#{tag_style}\">#{link_to "Register", new_user_registration_path, class: link_style}</li>".html_safe
    end
  end
  def sidebar_items
    [
      {
        url: "#",
        title: "Player ratings"
      },
      {
        url: "#",
        title: "Gaming results"
      },
      {
        url: "#",
        title: "Scenario publishers"
      },
      {
        url: "#",
        title: "Scenario publications"
      },
    ]
  end
  def header_items
    [
      {
        url: root_path,
        title: "Home"
      },
      {
        url: "#",
        title: "Add a game report"
      },
      {
        url: edit_user_registration_path,
        title: "Profile"
      }
    ]
  end
  def sidebar_helper tag_style, link_style, tag_type
    html = ''
    sidebar_items.each do |n|
      html << "<#{tag_type} class=\"#{tag_style}\"><a href=\"#{n[:url]}\" class=\"#{link_style} #{active? n[:url]}\">#{n[:title]}</a></#{tag_type}>"
    end
    html.html_safe
  end
  def header_helper tag_style, link_style, tag_type
    html = ''
    header_items.each do |n|
      html << "<#{tag_type} class=\"#{tag_style}\"><a href=\"#{n[:url]}\" class=\"#{link_style} #{active? n[:url]}\">#{n[:title]}</a></#{tag_type}>"
    end
    html.html_safe
  end

  def active? path
    "active" if current_page? path
  end
end
