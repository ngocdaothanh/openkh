class StaticBlock < Block
  acts_as_configurable do |c|
    c.string :title, :default => I18n.t('static_block.default.title')
    c.string :body,  :default => I18n.t('static_block.default.body')
  end

  validates_presence_of :title, :body
end
