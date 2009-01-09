class GoogleMapConf < Conf
  acts_as_configurable do |c|
    c.string :key, :default => I18n.t('google_map_conf.default.key')
  end

  validates_presence_of :key
end
