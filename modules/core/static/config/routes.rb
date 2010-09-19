Rails.application.routes.draw do
  match 'pages'       => 'pages#index', :as => 'pages'
  match 'pages/:slug' => 'pages#show',  :as => 'page'

  resources :admin_pages do
    collection do
      put 'batch_update'
    end
  end
end
