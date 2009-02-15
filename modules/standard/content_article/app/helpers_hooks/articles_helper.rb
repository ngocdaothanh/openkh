module ApplicationHelper
  def html_preview_article(article)
    article.introduction
  end

  def articles_feed(article)
    # .html.haml is needed for ATOM to work
    render('articles/feed.html.haml', :article => article)
  end
end
