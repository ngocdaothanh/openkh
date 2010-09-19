Rails.application.routes.draw do
  match 'javascripts/:file.js' => 'javascripts#show'

  resources :admin_blocks do
    collection do
      put 'batch_update'
    end
  end
end
