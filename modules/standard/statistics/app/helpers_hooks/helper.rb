module ApplicationHelper
  def top_users_block(block)
    users = User.all  # FIXME
    [t('top_users_block.title'), render('statistics/top_users_block', :users => users)]
  end

  def top_contents_block(block)
    contents = Article.all  # FIXME
    [t('top_contents_block.title'), render('statistics/top_contents_block', :contents => contents)]
  end
end
