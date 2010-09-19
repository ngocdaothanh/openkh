Rails.application.routes.draw do
  get 'groups'     => 'contents#index', :type => 'Group', :as => 'groups'
  get 'groups/new' => 'contents#new',   :type => 'Group', :as => 'new_group'
  get 'groups/:id' => 'contents#show',  :type => 'Group', :as => 'group'

  resources :groups do
    member do
      get 'version'
      get 'diff'
      put 'revert'
    end
  end
end
