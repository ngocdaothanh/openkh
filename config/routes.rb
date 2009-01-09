ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'site', :action => 'root'

  unless ::ActionController::Base.consider_all_requests_local
    map.connect '*path', :controller => 'site', :action => 'error_404'
  end
end
