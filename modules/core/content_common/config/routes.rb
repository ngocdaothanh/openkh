ActionController::Routing::Routes.draw do |map|
  map.with_options(:controller => 'contents') do |m|
    m.new_content 'new', :action => 'new_help'

    m.recent_contents 'recent_contents/:block_id', :action => 'recent'

    m.search 'search/:search_keyword', :action => 'search'
    m.search 'search/:search_keyword/:page', :action => 'search'

    m.feed 'feed', :action => 'feed', :format => :atom
  end
end
