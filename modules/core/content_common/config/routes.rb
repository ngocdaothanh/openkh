ActionController::Routing::Routes.draw do |map|
  map.new_content 'new', :controller => 'contents', :action => 'new_help'

  map.recent_contents 'recent_contents/:block_id', :controller => 'contents', :action => 'recent'
end
