module ActiveRecord
  module Acts
    module Commentable
      @@model_types = []

      def self.included(base)
        base.extend(ClassMethods)
      end

      def self.model_types
        @@model_types
      end

      module ClassMethods
        def acts_as_commentable
          ActiveRecord::Acts::Commentable.model_types << self.to_s
          has_many :comments

          include ActiveRecord::Acts::Commentable::InstanceMethods
        end
      end

      module InstanceMethods
        def after_destroy
          Comment.destroy_for(self.class.to_s, id)
        end
      end
    end
  end
end
