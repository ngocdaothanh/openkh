Rails.application.routes.draw do
  match 'login_with_unp' => 'login_unp#do_login', :method => :post, :as => 'login_with_unp'
end
