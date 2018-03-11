# All general view helpers go here. Header and sidebar menu contents omitted from Rubocop
module ApplicationHelper
  def login_helper(tag_info)
    html = ''
    if !current_user.is_a?(GuestUser)
      html << menu_link_builder(tag_info, { url: destroy_user_session_path, title: 'Logout' },
                                method: 'delete', rel: 'nofollow').html_safe
    else
      html << menu_link_builder(tag_info, { url: new_user_session_path, title: 'Login' }, method: nil, rel: nil)
      html << menu_link_builder(tag_info, { url: new_user_registration_path, title: 'Register' }, method: nil, rel: nil)
    end
    html.html_safe
  end

  def sidebar_items # rubocop:disable Metrics/MethodLength
    [
      # {
      #   url: "#",
      #   title: "Player ratings"
      # },
      # {
      #   url: "#",
      #   title: "Gaming results"
      # },
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

  def header_items # rubocop:disable Metrics/MethodLength
    [
      {
        url: root_path,
        title: 'Home'
      },
      {
        url: new_game_path,
        title: 'Add a game report'
      },
      {
        url: edit_user_registration_path,
        title: 'Profile'
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

  def header_helper(tag_info)
    html = ''
    header_items.each do |item|
      html << menu_link_builder(tag_info, { url: item[:url], title: item[:title] }, method: nil, rel: nil)
    end
    html.html_safe
  end

  def menu_link_builder(tag_info, url_options, options)
    format('<%<tag>s class="%<tag_style>s"><a href="%<url>s"' \
           'class="%<link_style>s %<active>s" %<method>s%<rel>s>%<title>s</a></%<tag>s>',
           tag: tag_info[:tag_type],
           tag_style: tag_info[:tag_style],
           url: url_options[:url],
           link_style: tag_info[:link_style],
           active: (active? url_options),
           title: url_options[:title],
           method: data_method(options[:method]),
           rel: rel(options[:rel]))
  end

  def data_method(input)
    return unless input
    "data-method=\"#{input}\""
  end

  def rel(input)
    return unless input
    "rel=\"#{input}\""
  end

  def active?(path)
    'active' if current_page? path[:url]
  end
end
