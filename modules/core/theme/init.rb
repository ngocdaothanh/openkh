# Themes, regions, and blocks are not reloaded during runtime
CONF[:theme] = SiteConf.instance.theme rescue nil  # nil when DB is not initialized

unless CONF[:theme].nil?
  # Views in theme directory take top priority
  # Cannot use view_paths.unshift
  ActionController::Base.view_paths = %W(#{Rails.root}/themes/#{CONF[:theme]}/app/views) + ActionController::Base.view_paths

  regions_blocks = YAML.load(File.read("#{Rails.root}/themes/#{CONF[:theme]}/regions_blocks.yml"))
  CONF[:regions] = regions_blocks['regions'].map { |e| e.intern }
end
