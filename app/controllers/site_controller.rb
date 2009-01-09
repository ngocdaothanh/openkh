class SiteController < ApplicationController
  def root
    render(:text => '', :layout => true)
  end

  def error_404
    render(:template => 'site/error_404', :layout => true, :status => 404)
  end
end
