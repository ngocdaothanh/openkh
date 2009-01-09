ActionController::Routing::Routes.draw do |map|
  map.login_www 'login_www', :controller => 'login_www', :action => 'do_login', :method => :post
end
