module ApplicationHelper
  def html_preview_event(event)
    sanitize(event.introduction)
  end
end
