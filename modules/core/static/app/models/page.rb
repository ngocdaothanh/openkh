class Page < ActiveRecord::Base
  acts_as_tree_without_loop :order => 'position'

  validates_presence_of :title, :slug, :body
  validates_numericality_of :position, :only_integer => true

  def self.tops
    find(:all, :conditions => {:parent_id => nil}, :order => 'position')
  end
end
