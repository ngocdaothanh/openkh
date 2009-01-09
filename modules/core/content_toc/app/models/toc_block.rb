class TocBlock < Block
  acts_as_configurable do |c|
    c.integer :toc_id
  end

  validates_presence_of :toc_id
  validates_numericality_of :toc_id, :only_integer => true
end
