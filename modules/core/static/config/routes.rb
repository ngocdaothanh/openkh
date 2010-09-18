Rails.application.routes.draw do
  match 'pages'       => 'pages#index', :as => 'pages'
  match 'pages/:slug' => 'pages#show', :as => 'page'

  resources :admin_pages, :collection => {:batch_update => :put}
end
