ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'login_openid' do |m|
    m.login_openid          'login_openid',           :action => 'do_login', :method => :post
    m.complete_login_openid 'login_openid/complete',  :action => 'complete', :method => :get
  end
end
