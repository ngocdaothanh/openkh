ActionController::Base.class_eval do
  private

  # Used by before filter.
  def check_captcha
    return unless CaptchaConf.instance.enabled

    if session[:captcha_passed] == true
      # Reset so that the same answer can not be used for multiple request
      session[:captcha_passed] = nil
    else
      # Invalid CAPTCHA code
      redirect_to(root_path)
    end
  end
end
