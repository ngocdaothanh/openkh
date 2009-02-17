# Themes, regions, and blocks are not reloaded during runtime
CONF[:theme] = SiteConf.instance.theme rescue nil  # nil when DB is not initialized

unless CONF[:theme].nil?
  # Views in theme directory take top priority
  # Cannot use view_paths.unshift
  ActionController::Base.view_paths = %W(#{RAILS_ROOT}/themes/#{CONF[:theme]}/app/views) + ActionController::Base.view_paths

  require "#{RAILS_ROOT}/themes/#{CONF[:theme]}/init"

  regions_blocks = YAML.load(File.read("#{RAILS_ROOT}/themes/#{CONF[:theme]}/regions_blocks.yml"))
  CONF[:regions] = regions_blocks['regions'].map { |e| e.intern }
end
