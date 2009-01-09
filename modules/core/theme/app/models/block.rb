class Block < ActiveRecord::Base
  has_and_belongs_to_many :categories

  validates_presence_of :region
  validates_presence_of :position

  def self.unassigneds
    ret = find(:all, :conditions => ['region < 0 OR region > ?', CONF[:regions].size - 1])
    ret.each { |b| b.region = -1 }
    ret
  end

  # index: index in the region array.
  def self.in_region(index)
    find(:all, :conditions => {:region => index}, :order => 'position')
  end
end
