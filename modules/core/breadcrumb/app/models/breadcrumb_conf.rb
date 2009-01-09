class BreadcrumbConf < Conf
  acts_as_configurable do |c|
    c.string  :prefix,            :default => I18n.t('breadcrumb_conf.default.prefix')
    c.string  :separator,         :default => '&raquo;'
    c.boolean :last_one_included, :default => true
  end
end
