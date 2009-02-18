class Toc < ActiveRecord::Base
  acts_as_versioned
  self.non_versioned_columns << 'updated_at'

  validates_presence_of :body

  def self.site_toc
    find(:first, :conditions => {:category_id => nil})
  end
end
