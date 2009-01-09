class LoginUnpController < ApplicationController
  before_filter :check_captcha, :only => [:do_login]

  add_breadcrumb I18n.t('user.users'), 'users_path'
  add_breadcrumb I18n.t('user.login'), '', :only => [:do_login]

  filter_parameter_logging :password

  def do_login
    user = UnpUser.login(params[:user][:user_name], params[:user][:password])
    if user.errors.empty?
      session[:me_id] = user.id
      redirect_to(root_path)
    else
      flash.now[:error_unp] = user.errors.full_messages[0]
      render(:template => 'users/login')
    end
  end
end
