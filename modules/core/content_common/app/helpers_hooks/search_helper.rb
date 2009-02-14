module ApplicationHelper
  def search_block(block)
    [t('search_block.title'), render('search/show', :block => block)]
  end
end
