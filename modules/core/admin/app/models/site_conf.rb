class SiteConf < Conf
  acts_as_configurable do |c|
    c.string  :title,                :default => 'OpenKH'
    c.string  :subtitle,             :default => 'Open Know-How'
    c.string  :admin_ids,            :default => '1'
    c.integer :new_threshold,        :default => 1
    c.string  :google_analytics_key, :default => 'Register at http://www.google.com/analytics/'
    c.string  :default_gravatar_id,  :default => 'blah'
  end

  validates_presence_of :title, :admin_ids
  validates_numericality_of :new_threshold, :only_integer => true, :greater_than => 0

  def before_validatation
    self.admin_ids = self.admin_ids.split(',').map { |i| i.to_i }.uniq.join(', ')
  end

  def admins
    ids = admin_ids.split(',').map { |i| i.to_i }
    User.find(:all, :conditions => {:id => ids})
  end

  def admin?(user)
    ids = admin_ids.split(',').map { |i| i.to_i }
    ids.include?(user.id)
  end
end
