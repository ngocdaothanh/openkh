module ActiveRecord
  module Acts
    module Content
      @@model_types = []

      def self.included(base)
        base.extend(ClassMethods)
      end

      def self.add_model_types(model_type)
        @@model_types << model_type
      end

      def self.model_types
        @@model_types.sort_by { |type| I18n.t("#{type.underscore}.name") }
      end

      module ClassMethods
        def acts_as_content
          ActiveRecord::Acts::Content.add_model_types(self.to_s)

          acts_as_commentable
          acts_as_uploadable
          acts_as_taggable

          has_many :categorizings, :as => :model, :dependent => :destroy
          has_many :categories, :through => :categorizings

          belongs_to :user

          validates_presence_of :title

          # Do not use normal methods so that classes that include this module
          # can have their own version of before_save and after_save.
          before_save 'self.category_ids = [Category.uncategorized.id] if category_ids.empty?'
          after_save  'Categorizing.updated_at(self.class.to_s, id, updated_at)'

          include ActiveRecord::Acts::Content::InstanceMethods
        end
      end

      module InstanceMethods
        def to_param
          sanitize_to_param("#{id}-#{title}")
        end

        # Increment the number of views for a content if the table has the column "views".
        def increment_views
          if self.class.column_names.include?('views')
            # increment! is not used to avoid callbacks and auto update.
            self.class.increment_counter(:views, self.id)
            self.views += 1
          end
        end
      end
    end
  end
end
