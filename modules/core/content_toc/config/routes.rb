ActionController::Routing::Routes.draw do |map|
  map.tocs    'tocs',     :controller => 'contents', :action => 'index', :type => 'Toc', :conditions => {:method => :get}
  map.new_toc 'tocs/new', :controller => 'contents', :action => 'new',   :type => 'Toc', :conditions => {:method => :get}
  map.toc     'tocs/:id', :controller => 'contents', :action => 'show',  :type => 'Toc', :conditions => {:method => :get}

  map.resources :tocs, :member => {:version => :get, :diff => :get, :revert => :put}
end
