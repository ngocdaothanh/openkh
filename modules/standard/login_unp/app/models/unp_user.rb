require 'digest/md5'

class UnpUser < User
  acts_as_configurable do |c|
    c.string :password, :default => ''
  end

  validates_presence_of :email, :password
  validates_confirmation_of :password

  # Returns a user. Empty errors on success or non-empty otherwise.
  def self.login(user_name, password)
    # Cannot find by both user name and password because password is a virtual field
    ret = UnpUser.find_by_user_name(user_name)

    wrong = false
    if !ret.nil?
      encrypted_password = Digest::MD5.hexdigest(password)
      wrong = (ret.password != encrypted_password)
    else
      ret = UnpUser.new(:user_name => user_name)
      wrong = true
    end
    ret.errors.add_to_base(I18n.t('login_unp.wrong_user_name_or_password')) if wrong

    ret
  end

  def before_save
    self.password = Digest::MD5.hexdigest(password)
  end
end
