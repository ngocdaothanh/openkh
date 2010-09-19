# will_paginate does not allow specifying "onclick" attribute of the pagination
# link. We need to create this renderer to do it.
#
# See will_paginate-3.0.pre/lib/will_paginate/view_helpers/link_renderer.rb
class AjaxLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
  def initialize(id)
    @id = id
  end

  def link(text, target, attributes = {})
    attributes[:onclick] = "return OpenKH.showPage('#{@id}', this.href)"
    super(text, target, attributes)
  end
end
