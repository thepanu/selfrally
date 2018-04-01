# All general view helpers go here. Header and sidebar menu contents omitted from Rubocop
module ApplicationHelper
  def wagering_odds(expected_score)
    return 'unknown' if expected_score.blank?
    (1 / expected_score).round(2)
  end

  def pregame_odds(expected_score)
    return 'unknown' if expected_score.blank?
    "#{(expected_score * 100).round(1)}%"
  end

  def game_status(status)
    format(' <span class="badge badge-%<badge>s">%<status>s</span>',
           badge: game_status_badge(status),
           status: status.capitalize).html_safe
  end

  def game_badges
    {
      'locked' => 'succes',
      'finished' => 'primary',
      'ongoing' => 'info'
    }
  end

  def game_status_badge(status)
    game_badges[status]
  end

  def login_helper(tag_info)
    html = ''
    if !current_user.is_a?(GuestUser)
      html << logout_link(tag_info)
    else
      html << login_link(tag_info)
      html << register_link(tag_info)
    end
    html.html_safe
  end

  def logout_link(tag_info)
    menu_link_builder(
      tag_info,
      { url: main_app.destroy_user_session_path, title: 'Logout' },
      method: 'delete',
      rel: 'nofollow'
    ).html_safe
  end

  def login_link(tag_info)
    menu_link_builder(
      tag_info,
      { url: main_app.new_user_session_path, title: 'Login' },
      method: nil,
      rel: nil
    )
  end

  def register_link(tag_info)
    menu_link_builder(tag_info,
                      { url: main_app.new_user_registration_path, title: 'Register' },
                      method: nil,
                      rel: nil)
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

  def submit_button_texts
    {
      'edit' => 'Save changes',
      'new' => 'Create new'
    }
  end

  def submit_button_helper(action)
    submit_button_texts[action]
  end
end
