require 'acts_as_commentable'

::ActiveRecord::Base.send(:include, ::ActiveRecord::Acts::Commentable)
