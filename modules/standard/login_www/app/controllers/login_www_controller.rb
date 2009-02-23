class LoginWwwController < ApplicationController
  before_filter :check_captcha, :only => [:do_login]

  add_breadcrumb I18n.t('user.users'), 'users_path'
  add_breadcrumb I18n.t('user.login'), :only => [:do_login]

  filter_parameter_logging :password

  def do_login
    if params[:user][:kind] == 'google'
      user = GoogleUser.login(params[:user][:user_name], params[:user][:password])
    else
      user = YahooUser.login(params[:user][:user_name], params[:user][:password])
    end

    if user.errors.empty?
      session[:me_id] = user.id
      Ip.create(:user_id => user.id, :ip => request.remote_ip)
      redirect_to(session[:destination] || root_path)
    else
      flash.now[:error_www] = user.errors.full_messages[0]
      render(:template => 'users/login')
    end
  end
end
