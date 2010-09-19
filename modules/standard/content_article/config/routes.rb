Rails.application.routes.draw do
  get 'articles'     => 'contents#index', :type => 'Article', :as => 'articles'
  get 'articles/new' => 'contents#new',   :type => 'Article', :as => 'new_article'
  get 'articles/:id' => 'contents#show',  :type => 'Article', :as => 'article'

  resources :articles do
    member do
      get 'version'
      get 'diff'
      put 'revert'
    end
  end

  resources :admin_articles
end
