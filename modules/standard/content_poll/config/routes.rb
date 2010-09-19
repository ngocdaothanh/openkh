Rails.application.routes.draw do
  get 'polls'     => 'contents#index', :type => 'Poll', :as => 'polls'
  get 'polls/new' => 'contents#new',   :type => 'Poll', :as => 'new_poll'
  get 'polls/:id' => 'contents#show',  :type => 'Poll', :as => 'poll'
  resources :polls
end
