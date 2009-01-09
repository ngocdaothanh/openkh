# sanitized_allowed_tags and sanitized_allowed_tags are sets, not arrays
# (http://www.ruby-doc.org/stdlib/libdoc/set/rdoc/index.html)

# Table
ActionView::Base.sanitized_allowed_tags.merge(%w(table tbody tr th td))
ActionView::Base.sanitized_allowed_attributes.merge(%w(colspan rowspan border align valign))

# Flash
ActionView::Base.sanitized_allowed_tags.merge(%w(object embed param))
ActionView::Base.sanitized_allowed_attributes.merge(%w(data type value))

# Color
ActionView::Base.sanitized_allowed_tags.merge(%w(strike font))
ActionView::Base.sanitized_allowed_attributes.merge(%w(bgcolor color face size style))

ActionView::Base.sanitized_allowed_tags.subtract(%w(div))
ActionView::Base.sanitized_allowed_attributes.subtract(%w(class))

module ActionView::Helpers::SanitizeHelper
  alias old_sanitize sanitize
  def sanitize(html, options = {})
    ret = old_sanitize(html, options)

    # Fix TinyMCE: replace &amp; with & (in URLs)
    ret.gsub!('&amp;', '&')

    # For TinyMCE: remove empty <p> </p>
    ret.gsub!(/<p>\s*?<\/p>/i, '')

    # Prevent Flash to access JS for security
    ret.gsub!(/<\s*?param\s*?name\s*?=\s*?("|'|)\s*?allowscriptaccess\s*?("|'|)/i, '<params name=""')

    ret
  end
end
