Rails.application.routes.draw do
  get 'events'     => 'contents#index', :type => 'Event', :as => 'events'
  get 'events/new' => 'contents#new',   :type => 'Event', :as => 'new_event'
  get 'events/:id' => 'contents#show',  :type => 'Event', :as => 'event'

  resources :events do
    member do
      post 'join'
      post 'unjoin'
    end
  end

  resources :admin_events
end
