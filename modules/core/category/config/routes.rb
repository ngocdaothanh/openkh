ActionController::Routing::Routes.draw do |map|
  map.categories 'categories',       :controller => 'categories', :action => 'index'
  map.category   'categories/:slug', :controller => 'categories', :action => 'show'

  map.resources :admin_categories, :collection => {:batch_update => :put}

  map.resources :links, :member => {:version => :get, :diff => :get, :revert => :put}
end
