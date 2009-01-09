ActionController::Routing::Routes.draw do |map|
  map.qas    'qas',     :controller => 'contents', :action => 'index', :type => 'Qa', :conditions => {:method => :get}
  map.new_qa 'qas/new', :controller => 'contents', :action => 'new',   :type => 'Qa', :conditions => {:method => :get}
  map.qa     'qas/:id', :controller => 'contents', :action => 'show',  :type => 'Qa', :conditions => {:method => :get}
  map.resources :qas

  map.resources :admin_qas
end
