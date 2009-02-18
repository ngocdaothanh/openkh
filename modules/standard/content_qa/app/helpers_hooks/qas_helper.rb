module ApplicationHelper
  def html_preview_qa(qa)
    ''
  end

  def qas_feed(qa)
    last_comment = Comment.last('Qa', qa.id)
    if last_comment.nil?
      qa.body
    else
      last_comment.body
    end
  end
end
