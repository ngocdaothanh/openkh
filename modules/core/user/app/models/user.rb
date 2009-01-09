class User < ActiveRecord::Base
  validates_presence_of :user_name

  def self.inherited(subclass)
    subclass.class_eval do
      # May be same user_name but different type
      validates_uniqueness_of :user_name

      def self.human_type
        self.to_s.underscore.gsub(/_user$/, '')
      end
    end

    super(subclass)
  end

  def to_param
    sanitize_to_param("#{id}-#{user_name}")
  end

  def admin?
    @admin ||= SiteConf.instance.admin?(self)
  end

  # FIXME
  def num_contents
    99
  end

  # FIXME
  def contents
    []
  end
end
