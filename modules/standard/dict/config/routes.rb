Rails.application.routes.draw do
  match 'dicts/:dict/:keyword' => 'dicts#search'
end
