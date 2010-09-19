require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module OpenKH
  class Application < Rails::Application
    # Load CONF before modules
    require File.join(File.dirname(__FILE__), 'conf')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Prevent error relating to autoreload in development environment, ex:
    # * "A copy of ApplicationController has been removed from the module tree but is still active!"
    # * undefined local variable or method `mod' for #<ContentsController:0x2475598>
    config.autoload_once_paths += %W{#{config.root}/app/controllers}

    config.paths.vendor.plugins << "#{config.root}/modules/core"
    config.paths.vendor.plugins << "#{config.root}/modules/standard"
    config.paths.vendor.plugins << "#{config.root}/themes/#{CONF[:theme]}"

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # All files from config/locales/*.rb,yml are added automatically.
    config.i18n.load_path += Dir[Rails.root.join('/modules/**/config/locales/*.{rb,yml}').to_s]
    config.i18n.default_locale = CONF[:locale]

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w()

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end

=begin

Rails::Initializer.run do |config|
  # Evaluate gems.rb from all modules
  files = Dir.glob("#{RAILS_ROOT}/modules/**/gems.rb")
  lines = files.inject('') { |tmp_lines, file| tmp_lines << File.read(file) }
  eval(lines)
end
=end
