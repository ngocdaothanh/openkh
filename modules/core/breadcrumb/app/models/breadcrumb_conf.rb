class BreadcrumbConf < Conf
  acts_as_configurable do |c|
    c.string  :prefix,            :default => ''
    c.string  :separator,         :default => '&raquo;'
    c.boolean :last_one_included, :default => true
  end
end
