Rails.application.routes.draw do
  match 'polls'     => 'contents#index', :type => 'Poll', :conditions => {:method => :get}, :as => 'polls'
  match 'polls/new' => 'contents#new',   :type => 'Poll', :conditions => {:method => :get}, :as => 'new_poll'
  match 'polls/:id' => 'contents#show',  :type => 'Poll', :conditions => {:method => :get}, :as => 'poll'
  resources :polls
end
