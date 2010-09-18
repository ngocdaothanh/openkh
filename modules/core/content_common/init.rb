require 'acts_as_content'

config.middleware.use ::ActionDispatch::Static, "#{root}/public"

::ActiveRecord::Base.send(:include, ::ActiveRecord::Acts::Content)
