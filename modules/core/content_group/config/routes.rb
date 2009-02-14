ActionController::Routing::Routes.draw do |map|
  map.tocs    'groups',     :controller => 'contents', :action => 'index', :type => 'Group', :conditions => {:method => :get}
  map.new_toc 'groups/new', :controller => 'contents', :action => 'new',   :type => 'Group', :conditions => {:method => :get}
  map.toc     'groups/:id', :controller => 'contents', :action => 'show',  :type => 'Group', :conditions => {:method => :get}

  map.resources :groups, :member => {:version => :get, :diff => :get, :revert => :put}
end
