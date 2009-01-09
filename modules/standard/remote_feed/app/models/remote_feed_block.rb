class RemoteFeedBlock < Block
  acts_as_configurable do |c|
    c.string  :feed_type, :default => 'RSS'
    c.string  :title,     :default => 'Slashdot'
    c.string  :url,       :default => 'http://rss.slashdot.org/Slashdot/slashdot'
    c.integer :limit,     :default => 10
  end

  validates_inclusion_of    :feed_type, :in => ['ATOM', 'RSS']
  validates_presence_of     :title, :url
  validates_numericality_of :limit, :only_integer => true, :greater_than_or_equal_to => 1
end
