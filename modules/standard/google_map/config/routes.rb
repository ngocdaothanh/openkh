Rails.application.routes.draw do
  resources :admin_google_map_markers

  match 'google_map_block/:id' => 'google_map_block#show', :as => 'google_map_block'
end
