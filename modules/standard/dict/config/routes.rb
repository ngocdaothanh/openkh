ActionController::Routing::Routes.draw do |map|
  map.connect 'dicts/search', :controller => 'dicts', :action => 'search'
end
