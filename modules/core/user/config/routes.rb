Rails.application.routes.draw do
  match 'login'  => 'users#login',  :as => 'login'
  match 'logout' => 'users#logout', :as => 'logout'

  resources :users, :member => {:pm => :post}
end
