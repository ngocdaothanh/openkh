Rails.application.routes.draw do
  post 'login_www' => 'login_www#do_login', :as => 'login_www'
end
