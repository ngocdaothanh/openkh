Rails.application.routes.draw do
  get 'qas'     => 'contents#index', :type => 'Qa', :as => 'qas'
  get 'qas/new' => 'contents#new',   :type => 'Qa', :as => 'new_qa'
  get 'qas/:id' => 'contents#show',  :type => 'Qa', :as => 'qa'
  resources :qas

  resources :admin_qas
end
