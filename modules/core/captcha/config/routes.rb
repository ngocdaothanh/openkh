ActionController::Routing::Routes.draw do |map|
  map.captcha 'captcha', :controller => 'captcha', :action => 'create'
end
