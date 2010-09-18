# The piece of code below must be put here, not in initializers, so that it is
# loaded *after* the helpers of the core.

# Modules ----------------------------------------------------------------------

# Helpers must be loaded *after* hooks in decreasing module priority:
# core -> standard -> extended
files = []
['app', 'modules/core', 'modules/standard', 'modules/extended'].each do |dir|
  ['admin_*_controller', '*helper', '*conf', '*block', '*hook'].each do |file|
    files += Dir.glob("#{Rails.root}/#{dir}/**/#{file}.rb")
  end
  files += Dir.glob("#{Rails.root}/#{dir}/**/models/**/*.rb")
end
files.each { |h| require(h) if h =~ /helpers_hooks/ }

# Include all helpers and hooks, all the time ----------------------------------

ApplicationController.class_eval do
  include ApplicationHelper
end

ActionView::Base.class_eval do
  include ApplicationHelper

  # Render only if the template exists. If the template is missing and there is
  # a block given, the block will be evaluated and returned.
  def render_if_exists(*args)
    render(*args)
  rescue ActionView::MissingTemplate
    block_given? ? yield : ''
  end
end
