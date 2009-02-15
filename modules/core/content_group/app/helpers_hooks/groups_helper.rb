module ApplicationHelper
  def html_preview_group(group)
    sanitize(group.introduction)
  end
end
