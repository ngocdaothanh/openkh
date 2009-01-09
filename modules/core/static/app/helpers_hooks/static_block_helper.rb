module ApplicationHelper
  def static_block(block)
    [block.title, block.body]
  end
end
