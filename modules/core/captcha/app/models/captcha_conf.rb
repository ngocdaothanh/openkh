class CaptchaConf < Conf
  acts_as_configurable do |c|
    c.boolean :enabled,     :default => false
    c.string  :public_key,  :default => I18n.t('captcha_conf.default.public_key')
    c.string  :private_key, :default => I18n.t('captcha_conf.default.private_key')
  end
end
