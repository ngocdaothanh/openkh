class ApplicationController < ActionController::Base
  # See config/initializers/fix_session_for_swfupload.rb
  protect_from_forgery
  def self.swfupload(actions)
    session :cookie_only => false, :only => actions
    protect_from_forgery :except => actions
  end

  # No layout for RSS views
  exempt_from_layout :builder

  before_filter :prepare_system_wide_variables

  add_breadcrumb I18n.t('common.home'), 'root_path'

  private

  # Prepares variables that are used at many places.
  def prepare_system_wide_variables
    mod[:me]         = User.find_by_id(session[:me_id]) unless session[:me_id].nil?
    mod[:categories] = Category.tops
  end

  # Let the user go to the intended destination after successful login.
  def remember_destination
    if params[:destination].nil?
      if params[:controller] == 'users' && params[:action] == 'login'
        session[:destination] = nil
      elsif request.get?
        session[:destination] = request.request_uri
      else
        session[:destination] = nil
      end
    else
      session[:destination] = params[:destination]
    end
  end

  # Compatible with both normal and Ajax requests.
  # Returns true if the check passed.
  def check_login
    ret = true
    if mod[:me].nil?
      s = t('common.please_login')
      if request.xhr?
        # See http://dev.rubyonrails.org/ticket/9360
        #render_js_with_status :update, :status => 400 do |page|
        #  page.alert(t('common.please_login'))
        #end
        render(:text => "alert('#{s}')", :status => 400, :layout => false)
        ret = false
      else
        flash[:notice] = s
        remember_destination
        redirect_to(login_path)
        ret = false
      end
    end
    ret
  end

  def check_login_and_admin
    if check_login && !mod[:me].admin?
      s = t('common.not_admin')
      if request.xhr?
        render(:text => "alert('#{s}')", :status => 400, :layout => false)
      else
        flash[:notice] = s
        redirect_to(root_path)
      end
    end
  end

  def render_no_permission(msg)
    ret = "<p class='notice'>#{msg}</p>"
    render(:text => ret, :layout => true)
  end

  #-----------------------------------------------------------------------------

  def rescue_action_in_public(exception)
    render(:template => 'site/error_500', :layout => true, :status => 500)
  end

  def local_request?
    false
  end
end
