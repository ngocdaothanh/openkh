Rails.application.routes.draw do
  match 'categories'       => 'categories#index', :as => 'categories'
  match 'categories/:slug' => 'categories#show',  :as => 'category'

  resources :admin_categories do
    collection do
      put 'batch_update'
    end
  end

  resources :links do
    member do
      get 'version'
      get 'diff'
      put 'revert'
    end
  end
end
