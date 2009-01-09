module ApplicationHelper
  def toc_block(block)
    toc = Toc.find(block.toc_id)
    [toc.title, render('toc_block/show', :toc => toc)]
  end
end
