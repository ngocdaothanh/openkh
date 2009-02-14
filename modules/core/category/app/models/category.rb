class Category < ActiveRecord::Base
  UNCATEGORIZED_NAME = 'UNCATEGORIZED_NAME'

  validates_presence_of :name, :slug
  validates_numericality_of :position, :only_integer => true

  acts_as_tree_without_loop :order => 'position'

  has_many :categorizings
  has_and_belongs_to_many :blocks
  has_one :toc

  def self.tops
    find(:all, :conditions => ['parent_id IS NULL AND name NOT LIKE ?', UNCATEGORIZED_NAME], :order => 'position')
  end

  def self.uncategorized
    find_by_name(UNCATEGORIZED_NAME)
  end

  def name
    n = super
    (n == UNCATEGORIZED_NAME)? I18n.t('category.uncategorized') : n
  end
end
