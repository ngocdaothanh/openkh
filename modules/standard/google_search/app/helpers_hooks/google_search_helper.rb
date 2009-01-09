module ApplicationHelper
  # Renders the Google search input text box.
  def google_search_block(block)
    [t('google_search.search'), render('google_search_block/show', :block => block)]
  end
end
