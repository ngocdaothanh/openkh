module ApplicationHelper
  def google_map_block(block)
    [block.title, render('google_map_block/show', :block => block, :fullscreen => false)]
  end
end
