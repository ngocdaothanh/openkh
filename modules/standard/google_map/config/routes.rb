ActionController::Routing::Routes.draw do |map|
  map.resources :admin_google_map_markers

  map.google_map_block 'google_map_block/:id', :controller => 'google_map_block', :action => 'show'
end
