class GoogleSearchBlock < Block
  acts_as_configurable do |c|
    c.string :key, :default => I18n.t('google_search_block.default.key')
  end

  validates_presence_of :key
end
