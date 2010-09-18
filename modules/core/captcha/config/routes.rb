Rails.application.routes.draw do
  match 'captcha' => 'captcha#create', :as => 'captcha'
end
