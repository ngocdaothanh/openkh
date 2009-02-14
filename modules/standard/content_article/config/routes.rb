ActionController::Routing::Routes.draw do |map|
  map.blikis    'blikis',     :controller => 'contents', :action => 'index', :type => 'Bliki', :conditions => {:method => :get}
  map.new_bliki 'blikis/new', :controller => 'contents', :action => 'new',   :type => 'Bliki', :conditions => {:method => :get}
  map.bliki     'blikis/:id', :controller => 'contents', :action => 'show',  :type => 'Bliki', :conditions => {:method => :get}
  map.resources :blikis, :member => {:version => :get, :diff => :get, :revert => :put}

  map.resources :admin_blikis
end
