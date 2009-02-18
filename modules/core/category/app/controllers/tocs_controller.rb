class TocsController < ApplicationController
  before_filter :check_login,   :only => [:new, :create, :edit, :update, :revert]
  before_filter :check_captcha, :only => [:create, :update, :revert]
  before_filter :find_category

  def new
    @toc = Toc.new(:category_id => params[:category_id])
    add_breadcrumb(t('common.create'))
  end

  def create
    @toc = Toc.new(params[:toc])
    @toc.user_id = mod[:me].id
    @toc.ip      = request.remote_ip
    if @toc.save
      path = @category.nil? ? root_path : category_path(@category)
      redirect_to(path)
    else
      add_breadcrumb(t('common.create'))
      render(:action => 'new')
    end
  end

  def edit
    @toc = Toc.find(params[:id])
    unless params[:version].nil?
      v = params[:version].to_i
      @toc.revert_to(v) if v != @toc.version
    end
    add_breadcrumb(t('common.edit'))
  end

  def update
    @toc = Toc.find(params[:id])

    # Avoid mass assignment for security
    @toc.body = params[:toc][:body]

    now = Time.now
    if mod[:me].id == @toc.user_id
      @toc.created_at = now  # Increase the last modification time
      saved = @toc.save_without_revision

      # We must manually update version DB
      if saved
        v = TocVersion.find(:first, :conditions => {
          :toc_id => @toc.id,
          :version => @toc.version})
        v.body = @toc.body
        v.created_at = now
        v.save
      end
    else
      @toc.user_id    = mod[:me].id
      @toc.ip         = request.remote_ip
      @toc.created_at = now  # Creation time of the new version
      saved = @toc.save
    end

    if saved
      path = @category.nil? ? root_path : category_path(@category)
      redirect_to(path)
    else
      content_add_breadcrumb(@toc)
      add_breadcrumb(t('common.edit'))
      render(:action => 'edit')
    end
  end

  # Ajax. Display a version.
  def version
    v = params[:version].to_i
    @toc = Toc.find(params[:id])
    @effective_version = @toc.version
    @toc.revert_to(v) if v != @effective_version
  end

  # Ajax.
  def diff
    @toc = Toc.find(params[:id])

    v1 = params[:v1].to_i
    @toc.revert_to(v1) if @toc.version != v1
    v1 = @toc.body

    v2 = params[:v2].to_i
    @toc.revert_to(v2)
    v2 = @toc.body

    @diff = HTMLDiff.diff(v1, v2)
  end

  # Ajax.
  def revert
    v = params[:version].to_i
    toc = Toc.find(params[:id])

    # updated_at is automatically updated
    toc.revert_to!(v) if v != toc.version

    render(:nothing => true)
  end

  private

  def find_category
    category_id = params[:category_id]
    category_id = params[:toc][:category_id] if category_id.nil? && !params[:toc].nil?

    @category = Category.find_by_id(category_id) unless category_id.nil?
    if @category.nil?
      unless category_id.nil?  # Could not find the specified category
        redirect_to(root_path)
        return
      end
      add_breadcrumb(t('toc_block.title_for_site'))
    else
      add_breadcrumb(t('category.categories'), categories_path)
      add_breadcrumb(@category.name, category_path(@category)) unless @category.nil?
      add_breadcrumb(t('toc_block.title'))
    end
  end
end
