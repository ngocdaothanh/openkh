Rails.application.routes.draw do
  match 'new' => 'contents#new_help', :as => 'new_content'

  match 'recent_contents/:block_id' => 'contents#recent', :as => 'recent_contents'

  match 'search/:search_keyword'       => 'contents#search', :as => 'search'
  match 'search/:search_keyword/:page' => 'search#index', :as => 'search'

  match 'feed' => 'contents#feed', :format => :atom, :as => 'feed'
end
