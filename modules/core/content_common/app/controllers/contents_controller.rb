class ContentsController < ApplicationController
  before_filter :check_login,  :only => [:new]
  before_filter :prepare_type, :only => [:index, :show, :new]

  add_breadcrumb I18n.t('content.create_new_content'), '', :only => [:new_help]

  def index
    add_breadcrumb(t("#{@klass.to_s.underscore}.name"))
    render(:layout => false) unless params[:page].nil?
  end

  def recent
    mod[:category] = Category.find(params[:category_id]) unless params[:category_id].nil?
    @block = RecentContentsBlock.find(params[:block_id])
    render(:layout => false)
  end

  def show
    singular = @type.downcase
    plural = singular.pluralize
    content = instance_variable_set("@#{singular}".intern, @klass.find(params[:id]))
    content.increment_views
    content_add_breadcrumb(content)
    @tpl = "#{plural}/show"
  end

  def new_help
  end

  def new
    singular = @type.downcase
    plural = singular.pluralize
    content = instance_variable_set("@#{singular}", @klass.new)
    add_breadcrumb(t("#{@klass.to_s.underscore}.name"), content_index_path(content))
    add_breadcrumb(t('common.create'))
    render(:template => "#{plural}/new")
  end

  def search
    @results = Article.search_for_keyword(params[:keyword])
    add_breadcrumb(t('search_block.title'))
    render('search/search')
  end

  private

  # Convert params[:type] which is passed from routes.rb of each content type to
  # ActiveRecord class.
  def prepare_type
    @type = params[:type]
    @klass = @type.constantize
  end
end
