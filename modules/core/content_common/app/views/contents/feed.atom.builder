atom_feed do |feed|
  feed.title(SiteConf.instance.title)
  feed.updated(@contents.first.updated_at) unless @contents.empty?

  @contents.each do |c|
    feed.entry(c, :url => content_show_path(c)) do |entry|
      entry.title(c.title)
      entry.author do |a|
        a.name(c.user.user_name)
      end
      entry.updated(c.updated_at)
    end
  end
end
