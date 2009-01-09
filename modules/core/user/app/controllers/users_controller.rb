class UsersController < ApplicationController
  before_filter :check_captcha, :only => [:pm]
  before_filter :check_login,   :only => [:pm]

  add_breadcrumb I18n.t('user.user'), 'users_path'
  add_breadcrumb I18n.t('user.login'), '', :only => [:login]

  def login
    if mod[:me].nil?
      remember_destination
    else
      redirect_to(root_path)
    end
  end

  def logout
    reset_session
    redirect_to(root_path)
  end

  def index
    @users = User.find(:all, :order => 'type, user_name')
  end

  def show
    @user = User.find(params[:id])
    add_breadcrumb(@user.user_name, '')
  end

  # Ajax.
  def pm
    message = params[:message].strip
    if message.empty?
      render(:update) do |page|
        page.alert(t('user.blank_message'))
        page << 'usersPMToggle()'
      end
      return
    end

    user = User.find(params[:id])
    Email.deliver_pm(mod[:me], user, message)
    render(:update) do |page|
      page.alert(t('user.sent'))
      page << 'usersPMToggle()'
    end
  rescue
    render(:update) do |page|
      page.alert(t('user.could_not_send'))
      page << 'usersPMToggle()'
    end
  end
end
