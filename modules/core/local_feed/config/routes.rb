ActionController::Routing::Routes.draw do |map|
  map.root_feed 'feeds/root', :controller => 'local_feeds', :action => 'root', :format => :atom
end
