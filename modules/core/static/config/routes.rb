ActionController::Routing::Routes.draw do |map|
  map.pages 'pages',       :controller => 'pages', :action => 'index'
  map.page  'pages/:slug', :controller => 'pages', :action => 'show'

  map.resources :admin_pages, :collection => {:batch_update => :put}
end
