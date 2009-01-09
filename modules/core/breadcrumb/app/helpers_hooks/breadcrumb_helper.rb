module ApplicationHelper
  # Build a series of links. The last one is the page title thus not included.
  def html_breadcrumbs
    conf = BreadcrumbConf.instance

    ilast = conf.last_one_included ? -1 : -2
    links = []
    @breadcrumbs[0..ilast].each_with_index do |a, i|
      title, path = a
      links << link_to_unless(i == (@breadcrumbs.size + ilast) || path.blank?, title, path)
    end

    @html_breadcrumbs = links.join(" #{conf.separator} ")
    @html_breadcrumbs = "#{conf.prefix} #{conf.separator} " + @html_breadcrumbs if !@html_breadcrumbs.blank? && !conf.prefix.blank?

    @html_breadcrumbs
  end

  def title_from_breadcrumbs
    @title_from_breadcrumbs ||= (@breadcrumbs.size > 1)? @breadcrumbs.last.first : nil
  end
end
