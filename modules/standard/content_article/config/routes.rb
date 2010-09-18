Rails.application.routes.draw do
  match 'articles'     => 'contents#index', :type => 'Article', :conditions => {:method => :get}, :as => 'articles'
  match 'articles/new' => 'contents#new',   :type => 'Article', :conditions => {:method => :get}, :as => 'new_article'
  match 'articles/:id' => 'contents#show',  :type => 'Article', :conditions => {:method => :get}, :as => 'article'
  resources :articles, :member => {:version => :get, :diff => :get, :revert => :put}

  resources :admin_articles
end
