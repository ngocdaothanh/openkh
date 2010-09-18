Rails.application.routes.draw do
  resources :uploads

  match 'admin_uploads' => 'admin_uploads', :as => 'admin_uploads'
end
