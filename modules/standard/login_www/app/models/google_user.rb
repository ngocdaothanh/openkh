class GoogleUser < User
  attr_accessor :kind
  attr_accessor :password

  # Returns user. Empty errors on success or non-empty otherwise.
  def self.login(user_name, password)
    only_user_name = user_name.gsub(/@.*/, '')

    agent = WWW::Mechanize.new
    agent.basic_auth(only_user_name, password)
    agent.get('https://mail.google.com/mail/feed/atom')

    ret = GoogleUser.find_by_user_name(only_user_name)
    if ret.nil?
      ret = GoogleUser.create(:user_name => only_user_name, :email => "#{only_user_name}@gmail.com")
    end
    ret
  rescue
    ret = GoogleUser.new(:user_name => user_name, :password => password)
    ret.errors.add_to_base(I18n.t('login_www.wrong_user_name_or_password'))
    ret
  end
end
