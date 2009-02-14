ActionController::Routing::Routes.draw do |map|
  map.categories 'categories',       :controller => 'categories', :action => 'index'
  map.category   'categories/:slug', :controller => 'categories', :action => 'show'

  map.resources :admin_categories, :collection => {:batch_update => :put}

  map.resources :tocs, :member => {:version => :get, :diff => :get, :revert => :put}, :path_prefix => 'categories/:slug'
end
