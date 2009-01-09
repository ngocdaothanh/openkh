ActionController::Routing::Routes.draw do |map|
  map.admin 'admin', :controller => 'admin'

  map.resources :admin_confs
end
