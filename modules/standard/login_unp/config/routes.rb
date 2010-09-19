Rails.application.routes.draw do
  post 'login_with_unp' => 'login_unp#do_login', :as => 'login_with_unp'
end
