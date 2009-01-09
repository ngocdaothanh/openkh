module ApplicationHelper
  # Injects the CAPTCHA dialog enabled.
  # form_or_function: HTML form id or JS function name
  # type: :form or :function
  def captcha(form_or_function, type)
    if CaptchaConf.instance.enabled
      "captcha.show(#{form_or_function})"
    else
      if type == :function
        "return #{form_or_function}()"
      else
        "#{form_or_function}.submit() }"
      end
    end
  end
end
