Rails.application.routes.draw do
  match 'login'  => 'users#login',  :as => 'login'
  match 'logout' => 'users#logout', :as => 'logout'

  resources :users do
    member do
      post 'pm'
    end
  end
end
