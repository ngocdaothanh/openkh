Rails.application.routes.draw do
  match 'categories' => 'categories#index', :as => 'categories'
  match 'categories/:slug' => 'categories#show', :as => 'category'

  resources :admin_categories, :collection => {:batch_update => :put}

  resources :links, :member => {:version => :get, :diff => :get, :revert => :put}
end
