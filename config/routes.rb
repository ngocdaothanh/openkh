OpenKH::Application.routes.draw do
  root :to => 'site#root'

  match '*path' => 'site#error_404'
end
