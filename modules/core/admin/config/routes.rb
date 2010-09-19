Rails.application.routes.draw do
  match 'admin' => 'admin#index', :as => 'admin'

  resources :admin_confs
end
