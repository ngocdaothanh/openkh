# Views in theme directory take top priority
# Cannot use view_paths.unshift
ActionController::Base.view_paths = %W(#{RAILS_ROOT}/themes/#{CONF[:theme]}/views) + ActionController::Base.view_paths

require "#{RAILS_ROOT}/themes/#{CONF[:theme]}/init"
