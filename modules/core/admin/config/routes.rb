Rails.application.routes.draw do
  match 'admin' => 'admin', :as => 'admin'

  resources :admin_confs
end
