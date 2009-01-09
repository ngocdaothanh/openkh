ActionController::Routing::Routes.draw do |map|
  map.connect 'javascripts/:file.js', :controller => 'javascripts', :action => 'show'
  map.connect 'plugin_assets/:module/javascripts/:file.js', :controller => 'javascripts', :action => 'show'

  map.resources :admin_blocks, :collection => {:batch_update => :put}
end
