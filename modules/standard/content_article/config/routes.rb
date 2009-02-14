ActionController::Routing::Routes.draw do |map|
  map.articles    'articles',     :controller => 'contents', :action => 'index', :type => 'Article', :conditions => {:method => :get}
  map.new_article 'articles/new', :controller => 'contents', :action => 'new',   :type => 'Article', :conditions => {:method => :get}
  map.article     'articles/:id', :controller => 'contents', :action => 'show',  :type => 'Article', :conditions => {:method => :get}
  map.resources :articles, :member => {:version => :get, :diff => :get, :revert => :put}

  map.resources :admin_articles
end
