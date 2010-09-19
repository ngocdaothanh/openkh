Rails.application.routes.draw do
  post 'login_openid'          => 'login_openid#do_login', :as => 'login_openid'
  get  'login_openid/complete' => 'login_openid#complete', :as => 'complete_login_openid'
end
