class RecentContentsBlock < Block
  acts_as_configurable do |c|
    c.string  :title, :default => I18n.t('recent_contents_block.default.title')
    c.string  :mode,  :default => 'preview'
    c.integer :limit, :default => 10
  end

  validates_inclusion_of :mode, :in => %w(preview title)
  validates_numericality_of :limit, :only_integer => true, :greater_than_or_equal_to => 1
end
