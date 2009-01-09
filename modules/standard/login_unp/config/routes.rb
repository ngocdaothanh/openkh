ActionController::Routing::Routes.draw do |map|
  map.login_with_unp 'login_with_unp', :controller => 'login_unp', :action => 'do_login', :method => :post
end
