class CaptchaController < ApplicationController
  layout nil

  skip_before_filter :verify_authenticity_token, :prepare_system_wide_variables

  # The client uses this action to give the captcha text.
  # The server responds status code 200 if the text is correct or else 400.
  def create
    status = 400
    begin
      res = Net::HTTP.post_form(URI.parse('http://api-verify.recaptcha.net/verify'), {
        'privatekey' => CaptchaConf.instance.private_key,
        'remoteip'   => request.remote_ip,
        'challenge'  => params[:recaptcha_challenge_field],
        'response'   => params[:recaptcha_response_field]})
      lines = res.body.split("\n")
      if lines[0] == 'true'
        status = 200
        session[:captcha_passed] = true
      end
    rescue
      status = 400
      session[:captcha_passed] = nil
    end
    render :nothing => true, :status => status
  end
end
