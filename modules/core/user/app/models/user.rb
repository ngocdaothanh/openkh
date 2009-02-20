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
    SiteConf.instance.admin?(self)
  end

  def num_contents
    ActiveRecord::Acts::Content.model_types.inject(0) do |ret, t|
      klass = t.constantize
      ret += klass.count(:conditions => {:user_id => self.id})
    end
  end

  def contents
    ActiveRecord::Acts::Content.model_types.inject([]) do |ret, t|
      klass = t.constantize
      ret.concat(klass.all(:conditions => {:user_id => self.id}))
    end
  end

  extend ActiveSupport::Memoizable
  memoize :to_param, :admin?, :num_contents, :contents
end
