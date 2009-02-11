module ApplicationHelper
  def dict_block(block)
    [t('dict_block.title'), render('dicts/block')]
  end

  def dict_result(result)
    content_tag(:b, h(result.entry)) + ' [' + h(result.pronunciation) + ']<br />' +
    h(result.description)
  end
end
