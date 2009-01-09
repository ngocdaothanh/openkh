module ApplicationHelper
  def chat_block(block)
    [t('chat_block.title'), render('chat_block/show', :block => block)]
  end
end
