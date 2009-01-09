class AdminController < ApplicationController
  before_filter :check_login_and_admin

  add_breadcrumb I18n.t('common.admin'), 'admin_path'

  def index
    @titles_paths = []
    self.class.subclasses.each do |c|
      index_path = url_for(:controller => c.underscore.gsub(/_controller$/, ''), :action => 'index', :only_path => true)
      breadcrumbs = c.constantize.breadcrumbs  # See module breadcrumb
      next if breadcrumbs.nil?

      breadcrumbs.each do |title, path|
        path = eval(path) if path =~ /_path|_url|@/
        if path == index_path
          @titles_paths << [title, index_path]
          break
        end
      end
    end
    @titles_paths = @titles_paths.sort_by { |title, path| title }
  end
end
