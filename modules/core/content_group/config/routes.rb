Rails.application.routes.draw do
  match 'groups'     => 'contents#index', :type => 'Group', :conditions => {:method => :get}, :as => 'groups'
  match 'groups/new' => 'contents#new',   :type => 'Group', :conditions => {:method => :get}, :as => 'new_group'
  match 'groups/:id' => 'contents#show',  :type => 'Group', :conditions => {:method => :get}, :as => 'group'

  resources :groups, :member => {:version => :get, :diff => :get, :revert => :put}
end
