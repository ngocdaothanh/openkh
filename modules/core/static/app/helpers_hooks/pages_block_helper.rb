module ApplicationHelper
  def pages_block(block)
    content = ''.html_safe
    pages = Page.tops
    unless pages.empty?
      pages.each do |page|
        content << html_tree(page) { |p, level| [link_to(p.title, page_path(:slug => p.slug))] }
      end
      content = content_tag(:ul, content, :class => 'tree pages')
    end
    [t('static.pages'), content]
  end
end
