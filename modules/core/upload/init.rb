require 'acts_as_uploadable'

::ActiveRecord::Base.send(:include, ::ActiveRecord::Acts::Uploadable)
