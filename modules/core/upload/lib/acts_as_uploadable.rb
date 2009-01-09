module ActiveRecord
  module Acts
    module Uploadable
      @@model_types = []

      def self.included(base)
        base.extend(ClassMethods)
      end

      def self.model_types
        @@model_types
      end

      module ClassMethods
        def acts_as_uploadable
          ActiveRecord::Acts::Uploadable.model_types << self.to_s

          include ActiveRecord::Acts::Uploadable::InstanceMethods
        end
      end

      module InstanceMethods
        def after_destroy
          Upload.destroy_for(self.class.to_s, id)
        end
      end
    end
  end
end
