# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#-------------------------------------------------------------------------------

# Load CONF before modules
require File.join(File.dirname(__FILE__), 'conf')

#-------------------------------------------------------------------------------

Rails::Initializer.run do |config|
  # Compass needs HAML to be installed as gem, not in vendor/plugins/haml
  config.gem 'haml', :version => '>= 2.1'
  config.gem 'chriseppstein-compass', :version => '>= 0.3.7'

  # Evaluate gems.rb from all modules
  files = Dir.glob("#{RAILS_ROOT}/modules/**/gems.rb")
  lines = files.inject('') { |tmp_lines, file| tmp_lines << File.read(file) }
  eval(lines)

  config.time_zone = 'UTC'
  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  config.i18n.load_path += Dir[File.join(RAILS_ROOT, '/modules/**/config/locales/*.{rb,yml}')]
  config.i18n.default_locale = CONF[:locale]

  config.plugin_paths += %W(
    #{RAILS_ROOT}/modules/core
    #{RAILS_ROOT}/modules/standard
    #{RAILS_ROOT}/modules/extended)

  # Prevent error relating to autoreload in development environment, ex:
  # * "A copy of ApplicationController has been removed from the module tree but is still active!"
  # * undefined local variable or method `mod' for #<ContentsController:0x2475598>
  config.load_once_paths += %W{#{RAILS_ROOT}/app/controllers}

  # Only load the plugins named here, in the order given. By default, all plugins
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [:exception_notification, :ssl_requirement, :all]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W(#{RAILS_ROOT}/extras)

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
end

# The piece of code below must be put here, not in initializers, so that it is
# loaded *after* the helpers of the core.

# Modules ----------------------------------------------------------------------

# Helpers must be loaded *after* hooks in decreasing module priority:
# core -> standard -> extended
files = []
['app', 'modules/core', 'modules/standard', 'modules/extended'].each do |dir|
  ['admin_*_controller', '*helper', '*conf', '*block', '*hook'].each do |file|
    files += Dir.glob("#{RAILS_ROOT}/#{dir}/**/#{file}.rb")
  end
  files += Dir.glob("#{RAILS_ROOT}/#{dir}/**/models/**/*.rb")
end
files.each { |h| require(h) }

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
