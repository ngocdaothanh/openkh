ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'users' do |m|
    m.login  'login',  :action => 'login'
    m.logout 'logout', :action => 'logout'
  end
  map.resources :users, :member => {:pm => :post}
end
