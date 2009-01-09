# TinyMCE is big, so we try to avoid loading TinyMCE if there's no text area.

module ActionView::Helpers::FormHelper
  alias old_text_area text_area
  def text_area(object_name, method, options = {})
    mod[:wysiwyg] = true if options[:class] !~ /mce_no_editor/
    old_text_area(object_name, method, options)
  end
end

module ActionView::Helpers::FormTagHelper
  alias old_text_area_tag text_area_tag
  def text_area_tag(name, content = nil, options = {})
    mod[:wysiwyg] = true if options[:class] !~ /mce_no_editor/
    old_text_area_tag(name, content, options)
  end
end
