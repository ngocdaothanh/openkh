module ApplicationHelper
  # type   Content class name
  # mode   :preview or :title
  # limit  Default 10
  def html_content_index(type, page, mode, limit = 10)
    contents = type.constantize.paginate(
      :page          => page,
      :total_entries => limit,
      :order         => 'updated_at DESC')

    if contents.empty?
      content = ''
    else
      options = {:controller => 'contents', :action => 'index', :type => type}
      content = render("contents/index_#{mode.to_s.pluralize}", :contents => contents, :options => options)
    end

    content
  end

  #-----------------------------------------------------------------------------

  # The header is usually simple and common for all view mode, thus should be
  # grouped in only one partial.
  def html_content_header(content, no_user_info = false)
    render("contents/html_header", :content => content, :no_user_info => no_user_info)
  end

  # Renders information about of a content (author, created_at, updated_at...).
  def html_content_user_info(content)
    extra_row = t('common.time_ago', :dt => time_ago_in_words(content.created_at)).html_safe
    extra_row.capitalize!
    html_user_info(content.user, extra_row)
  end

  def html_content_contributors(content)
    # FIXME
    users = []
    html_blocklike_show(
      t('content.contributors'),
      render('contents/contributors', :users => users))
  end

  def html_content_bookmarks(content)
    title = content.title
    url   = send("#{content.class.to_s.downcase}_url", content)

    bookmarks = [
      {:site => 'del.icio.us',      :icon => 'del.icio.us', :url => 'http://del.icio.us/post',                                            :title_uri => 'title', :url_uri => 'url'},
      {:site => 'Digg',             :icon => 'digg',        :url => 'http://digg.com/submit?phase=2',                                     :title_uri => 'title', :url_uri => 'url'},
      {:site => 'Furl',             :icon => 'furl',        :url => 'http://www.furl.net/storeIt.jsp',                                    :title_uri => 't',     :url_uri => 'u'},
      {:site => 'Reddit',           :icon => 'reddit',      :url => 'http://reddit.com/submit',                                           :title_uri => 'title', :url_uri => 'url'},
      {:site => 'Yahoo!',           :icon => 'yahoo',       :url => 'http://myweb2.search.yahoo.com/myresults/bookmarklet?popup=true',    :title_uri => 'title', :url_uri => 'u'},
      {:site => 'StumbleUpon',      :icon => 'stumbleupon', :url => 'http://www.stumbleupon.com/submit',                                  :title_uri => 'title', :url_uri => 'url'},
      {:site => 'Google Bookmarks', :icon => 'google',      :url => 'http://www.google.com/bookmarks/mark?op=edit',                       :title_uri => 'title', :url_uri => 'bkmk'},
      {:site => 'Live Favorites',   :icon => 'live',        :url => 'https://favorites.live.com/quickadd.aspx?marklet=1&mkt=en-us&top=1', :title_uri => 'title', :url_uri => 'url'},
      {:site => 'Technorati',       :icon => 'technorati',  :url => 'http://www.technorati.com/faves',                                                           :url_uri => 'add'}
    ]

    html_blocklike_show(
      t('content.bookmarks'),
      render('contents/bookmarks', :title => title, :url => url, :bookmarks => bookmarks))
  end

  # Returns an array of groups containing the content.
  def html_content_groups(content)
    con = ActiveRecord::Base.connection
    content_type = con.quote(content.class.to_s)
    group_ids = con.select_values("SELECT group_id FROM contents_groups WHERE content_type = #{content_type} AND content_id = #{content.id}")
    if group_ids.empty?
      ''
    else
      groups = Toc.find(:all, :conditions => {:id => group_ids})
      html_blocklike_show(
        t('content.groups'),
        render('contents/groups', :groups => groups))
    end
  end

  def html_content_version_pager(content, effective_version)
    # contents_version_with_pager(@toc, @effective_version, 'toc_versions', diff_toc_path(@toc), revert_toc_path(@toc)) { |v| version_toc_path(@toc, :version => v) }
  end

  #-----------------------------------------------------------------------------

  def content_recent?(content)
    Time.now - content.updated_at < SiteConf.instance.new_threshold*24*60*60
  end

  def content_index_path(content)
    return send("#{content.class.to_s.downcase.pluralize}_path")
  end

  def content_show_path(content)
    return send("#{content.class.to_s.downcase}_path", content)
  end

  #-----------------------------------------------------------------------------

  def content_add_breadcrumb(content)
    #add_breadcrumb(mod[:category].name, tag_path(mod[:category])) if mod[:category]
    add_breadcrumb(t("#{content.class.to_s.underscore}.name"), content_index_path(content))
    add_breadcrumb(content.title, content_show_path(content))
  end
end
