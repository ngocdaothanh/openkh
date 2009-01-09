require 'acts_as_content'

::ActiveRecord::Base.send(:include, ::ActiveRecord::Acts::Content)
