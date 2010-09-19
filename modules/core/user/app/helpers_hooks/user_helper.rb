module ApplicationHelper
  def full_user_name(user)
    "#{user.class.human_type}/#{user.user_name}"
  end

  def current_user_block(block)
    title = mod[:me].nil? ? t('user.login') : full_user_name(mod[:me])
    content = render('current_user_block/show')
    [html_user_gravatar(mod[:me]) + ' ' + title, content]
  end

  #-----------------------------------------------------------------------------

  # Renders author of a content (may be not a content).
  def html_user_author(content)
    extra_row = t('common.time_ago', :dt => time_ago_in_words(content.created_at))
    html_user_info(content.user, extra_row)
  end

  # Renders information about any user.
  def html_user_info(user, extra_row = nil, *extra_columns)
    user.nil? ? '' : render(
      'users/html_info',
      :user => user, :extra_row => extra_row, :extra_columns => extra_columns)
  end

  def html_user_content_count(user)
    if user.num_contents == 0
      ''
    else
      "#{theme_image_tag('contents.png', :title => t('user.contributed_contents'))} #{user.num_contents}".html_safe
    end
  end

  def html_user_gravatar(user)
    if user.nil? || user.email.nil?
      gravatar_id = SiteConf.instance.default_gravatar_id
    else
      gravatar_id = Digest::MD5.hexdigest(user.email)
    end
    image = image_tag("http://www.gravatar.com/avatar.php?size=30&gravatar_id=#{gravatar_id}", :title => 'Gravatar')
    return link_to(image, 'http://gravatar.com/')
  end

  #-----------------------------------------------------------------------------

  # destination: nil to return to the current page
  def user_link_to_login(name, destination = nil)
    if destination.nil?
      # FIXME
      #destination = <current page>
    end
    return link_to(name, login_path(:destination => destination))
  end
end
