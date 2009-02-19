module ApplicationHelper
  def toc_block(block)
    category = mod[:category]

    if category.nil? || category.uncategorized?
      title = t('toc_block.title_for_site')
      toc = Toc.site_toc
    else
      title = t('toc_block.title_for_category', :name => category.name)
      toc = category.toc
    end
    category_id = category.nil? ? nil : category.id
    [title, render('tocs/block', :category_id => category_id, :toc => toc)]
  end
end
