ActionController::Routing::Routes.draw do |map|
  map.connect 'dicts/:dict/:keyword', :controller => 'dicts', :action => 'search'
end
