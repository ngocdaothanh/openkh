Rails.application.routes.draw do
  match 'qas'     => 'contents#index', :type => 'Qa', :conditions => {:method => :get}, :as => 'qas'
  match 'qas/new' => 'contents#new',   :type => 'Qa', :conditions => {:method => :get}, :as => 'new_qa'
  match 'qas/:id' => 'contents#show',  :type => 'Qa', :conditions => {:method => :get}, :as => 'qa'
  resources :qas

  resources :admin_qas
end
