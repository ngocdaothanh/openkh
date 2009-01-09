ActionController::Routing::Routes.draw do |map|
  map.polls    'polls',     :controller => 'contents', :action => 'index', :type => 'Poll', :conditions => {:method => :get}
  map.new_poll 'polls/new', :controller => 'contents', :action => 'new',   :type => 'Poll', :conditions => {:method => :get}
  map.poll     'polls/:id', :controller => 'contents', :action => 'show',  :type => 'Poll', :conditions => {:method => :get}
  map.resources :polls
end
