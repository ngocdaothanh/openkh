module ApplicationHelper
  def qas_feed(qa)
    last_comment = Comment.last('Qa', qa.id)
    if last_comment.nil?
      qa.message
    else
      last_comment.message
    end
  end
end
