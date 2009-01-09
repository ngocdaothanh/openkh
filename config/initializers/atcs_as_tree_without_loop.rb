class ActiveRecord::Base
  def self.acts_as_tree_without_loop(options = {})
    acts_as_tree(options)

    self.class_eval do
      def self_and_subnodes_at_all_depths
        if @self_and_subnodes_at_all_depths.nil?
          @self_and_subnodes_at_all_depths = [self]
          children.each { |c| @self_and_subnodes_at_all_depths.concat(c.self_and_subnodes_at_all_depths) }
        end
        @self_and_subnodes_at_all_depths
      end

      # Do not use "def validate" to avoid overriding or being overriden.
      validates_each :parent_id do |record, attr, value|
        unless value.nil?
          ids = record.self_and_subnodes_at_all_depths.map { |n| n.id }
          record.errors.add(:parent_id) if ids.include?(value)
        end
      end
    end
  end
end
