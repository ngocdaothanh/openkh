class YahooUser < User
  attr_accessor :kind
  attr_accessor :password

  # Returns user. Empty errors on success or non-empty otherwise.
  def self.login(user_name, password)
    only_user_name = user_name.gsub(/@.*/, '')

    # http://schf.uc.org/articles/2007/02/14/scraping-gmail-with-mechanize-and-hpricot
    agent = WWW::Mechanize.new

    page = agent.get('https://login.yahoo.com/config/login_verify2')
    form = page.forms.first
    form.login = only_user_name
    form.passwd = password
    page = agent.submit(form)
    if page.links.first.href == 'http://my.yahoo.com'
      ret = YahooUser.find_by_user_name(only_user_name)
      if ret.nil?
        ret = YahooUser.create(:user_name => only_user_name, :email => "#{only_user_name}@yahoo.com")
      end
      ret
    else
      raise
    end
  rescue
    ret = YahooUser.new(:user_name => user_name, :password => password)
    ret.errors.add_to_base(I18n.t('login_www.wrong_user_name_or_password'))
    ret
  end
end
