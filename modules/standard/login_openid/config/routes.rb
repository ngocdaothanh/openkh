Rails.application.routes.draw do
  match 'login_openid'          => 'login_openid#do_login', :method => :post, :as => 'login_openid'
  match 'login_openid/complete' => 'login_openid#complete', :method => :get,  :as => 'complete_login_openid'
end
