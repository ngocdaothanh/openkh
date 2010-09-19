module ApplicationHelper
  # Renders comment list and lets logged in user create new comment.
  # scroll: true to scroll to the last comment.
  def html_comment_all(object, scroll = false)
    comments = Comment.paginate(
      :page       => 1,
      :conditions => {Comment.key(object) => object.id},
      :order      => 'created_at ASC')

    # FIXME
    #comments.last_page!

    # Always render even if comments is empty, because the block content always
    # includes input form or link to login
    html_blocklike_show(
      t('comment.comments'),
      render('comments/all', :object => object, :scroll => scroll, :comments => comments))
  end

  # Renders the last comment.
  def html_comment_last(object)
    comment = Comment.last(object)
    comment.nil? ? '' : render('comments/last', :comment => comment)
  end
end
