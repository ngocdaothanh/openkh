ActionController::Routing::Routes.draw do |map|
  map.events    'events',     :controller => 'contents', :action => 'index', :type => 'Event', :conditions => {:method => :get}
  map.new_event 'events/new', :controller => 'contents', :action => 'new',   :type => 'Event', :conditions => {:method => :get}
  map.event     'events/:id', :controller => 'contents', :action => 'show',  :type => 'Event', :conditions => {:method => :get}
  map.resources :events, :member => {:join => :post, :unjoin => :post}

  map.resources :admin_events
end
