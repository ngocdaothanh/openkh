module ApplicationHelper
  def link_block(block)
    category = mod[:category]

    if category.nil? || category.uncategorized?
      title = t('link_block.title_for_site')
      link = Link.site_links
    else
      title = t('link_block.title_for_category', :name => category.name)
      link = category.link
    end
    category_id = category.nil? ? nil : category.id
    [title, render('links/block', :category_id => category_id, :link => link)]
  end
end
