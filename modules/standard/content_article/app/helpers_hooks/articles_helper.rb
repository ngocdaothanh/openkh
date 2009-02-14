module ApplicationHelper
  # Used by module local_feed.
  def articles_feed(article)
    # .html.haml is needed for ATOM to work
    render('articles/feed.html.haml', :article => article)
  end
end
