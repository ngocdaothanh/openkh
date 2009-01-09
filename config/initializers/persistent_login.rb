# Only expire sessions when the cookie is deleted or users explicitly log out
ActionController::Base.session_options[:session_expires] = Time.local(2031, 'jan')
