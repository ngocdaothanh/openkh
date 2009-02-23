class LoginOpenidController < ApplicationController
  add_breadcrumb I18n.t('user.users'), 'users_path'
  add_breadcrumb I18n.t('user.login'), :only => [:do_login]

  def do_login
    begin
      oidreq = openid_consumer.begin(params[:user][:openid].strip)
      sregreq = OpenID::SReg::Request.new
      sregreq.request_fields(['email','nickname'], false)
      oidreq.add_extension(sregreq)
      oidreq.return_to_args['did_sreg'] = 'y'
      return_to = complete_login_openid_url  # Must be absolute URL
      realm = root_url                      #         "
      if oidreq.send_redirect?(realm, return_to, nil)
        dest = oidreq.redirect_url(realm, return_to, nil)
      end
    rescue
      logger.error($!)
      logger.error($!.backtrace.join("\n"))
      dest = nil
    end

    if dest.nil?
      flash.now[:error_openid] = t('login_openid.invalid')
      render(:template => 'users/login')
    else
      redirect_to(dest)
    end
  end

  def complete
    current_url = url_for(:action => 'complete', :only_path => false)
    parameters = params.reject{ |k, v| request.path_parameters[k] }
    oidresp = openid_consumer.complete(parameters, current_url)
    sreg_resp = OpenID::SReg::Response.from_success_response(oidresp)

    if oidresp.status == OpenID::Consumer::SUCCESS
      # Create user or update email
      openid = oidresp.display_identifier.strip.gsub(/^http(s|):\/\/|\/$/, '')
      me = User.find_by_user_name(openid)
      email = sreg_resp.empty? ? nil : sreg_resp.data['email']
      if me.nil?
        me = OpenidUser.new(:user_name => openid, :email => email)
        me.save
      elsif me.email != email
        me.update_attribute(:email, email)
      end

      if me.errors.empty?
        session[:me_id] = me.id  # Login
        Ip.create(:user_id => me.id, :ip => request.remote_ip)
        redirect_to(session[:destination] || root_path)
      end
    else
      raise
    end
  rescue
    logger.error($!)
    logger.error($!.backtrace.join("\n"))
    flash[:error_openid] = t('login_openid.could_not_login')
    redirect_to(login_path)
  end

  private

  def openid_consumer
    @openid_consumer ||= OpenID::Consumer.new(session, OpenID::Store::Filesystem.new("#{RAILS_ROOT}/tmp/openid"))
  end
end
