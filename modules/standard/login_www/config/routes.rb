Rails.application.routes.draw do
  match 'login_www' => 'login_www#do_login', :method => :post, :as => 'login_www'
end
