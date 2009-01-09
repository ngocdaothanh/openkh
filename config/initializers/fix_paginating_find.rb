# Do not display links if there's only one page.
module PaginatingFind
  module Helpers
    alias old_paginating_links paginating_links

    def paginating_links(paginator, options = {}, html_options = {})
      return if paginator.page_count < 2
      old_paginating_links(paginator, options, html_options)
    end
  end
end
