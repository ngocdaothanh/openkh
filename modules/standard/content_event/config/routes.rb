Rails.application.routes.draw do
  match 'events'     => 'contents#index', :type => 'Event', :conditions => {:method => :get}, :as => 'events'
  match 'events/new' => 'contents#new',   :type => 'Event', :conditions => {:method => :get}, :as => 'new_event'
  match 'events/:id' => 'contents#show',  :type => 'Event', :conditions => {:method => :get}, :as => 'event'
  resources :events, :member => {:join => :post, :unjoin => :post}

  resources :admin_events
end
