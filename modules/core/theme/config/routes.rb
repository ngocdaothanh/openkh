Rails.application.routes.draw do
  match 'javascripts/:file.js' => 'javascripts#show'
  match 'plugin_assets/:module/javascripts/:file.js' => 'javascripts#show'

  resources :admin_blocks, :collection => {:batch_update => :put}
end
