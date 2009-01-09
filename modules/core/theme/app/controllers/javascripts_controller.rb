class JavascriptsController < ApplicationController
  layout nil
  skip_before_filter :verify_authenticity_token, :prepare_system_wide_variables

  def show
    # Sanitize
    if params[:file] =~ /^[a-z_]/
      render(:template => "javascripts/#{params[:file]}.js.erb", :content_type => 'text/javascript')
    else
      render(:nothing => true, :status => 404)
    end
  end
end
