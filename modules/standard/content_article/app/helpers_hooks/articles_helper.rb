module ApplicationHelper
  # Used by module local_feed.
  def blikis_feed(bliki)
    # .html.haml is needed for ATOM to work
    render('blikis/feed.html.haml', :bliki => bliki)
  end
end
