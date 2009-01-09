ActionController::Routing::Routes.draw do |map|
  map.resources :uploads

  map.admin_uploads 'admin_uploads', :controller => 'admin_uploads'
end
