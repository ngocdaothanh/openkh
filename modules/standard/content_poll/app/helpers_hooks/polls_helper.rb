module ApplicationHelper
  def html_preview_poll(poll)
    render('polls/poll', :poll => poll)
  end

  def poll_feed(poll)
    poll_preview(poll)
  end

  def html_poll_bar(poll, index)
    if poll.sum == 0
      value = 0
      percent = 100
    else
      value = poll.votes[index]
      percent = 100*value/poll.sum
    end
    percent = 3 if percent < 3

    content_tag(:div, value, :style => "width: #{percent}%", :class => 'poll_bar')
  end
end
