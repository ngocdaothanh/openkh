class LinksController < ApplicationController
  before_filter :check_login,   :only => [:new, :create, :edit, :update, :revert]
  before_filter :check_captcha, :only => [:create, :update, :revert]
  before_filter :find_category

  def new
    @link = Link.new(:category_id => params[:category_id])
    add_breadcrumb(t('common.create'))
  end

  def create
    @link = Link.new(params[:link])
    @link.user_id = mod[:me].id
    @link.ip      = request.remote_ip
    if @link.save
      path = @category.nil? ? root_path : category_path(@category)
      redirect_to(path)
    else
      add_breadcrumb(t('common.create'))
      render(:action => 'new')
    end
  end

  def edit
    @link = Link.find(params[:id])
    unless params[:version].nil?
      v = params[:version].to_i
      @link.revert_to(v) if v != @link.version
    end
    add_breadcrumb(t('common.edit'))
  end

  def update
    @link = Link.find(params[:id])

    # Avoid mass assignment for security
    @link.body = params[:link][:body]

    now = Time.now
    if mod[:me].id == @link.user_id
      @link.created_at = now  # Increase the last modification time
      saved = @link.save_without_revision

      # We must manually update version DB
      if saved
        v = LinkVersion.find(:first, :conditions => {
          :link_id => @link.id,
          :version => @link.version})
        v.body = @link.body
        v.created_at = now
        v.save
      end
    else
      @link.user_id    = mod[:me].id
      @link.created_at = now  # Creation time of the new version
      saved = @link.save
    end

    if saved
      path = @category.nil? ? root_path : category_path(@category)
      redirect_to(path)
    else
      content_add_breadcrumb(@link)
      add_breadcrumb(t('common.edit'))
      render(:action => 'edit')
    end
  end

  # Ajax. Display a version.
  def version
    v = params[:version].to_i
    @link = Link.find(params[:id])
    @effective_version = @link.version
    @link.revert_to(v) if v != @effective_version
  end

  # Ajax.
  def diff
    @link = Link.find(params[:id])

    v1 = params[:v1].to_i
    @link.revert_to(v1) if @link.version != v1
    v1 = @link.body

    v2 = params[:v2].to_i
    @link.revert_to(v2)
    v2 = @link.body

    @diff = HTMLDiff.diff(v1, v2)
  end

  # Ajax.
  def revert
    v = params[:version].to_i
    link = Link.find(params[:id])

    # updated_at is automatically updated
    link.revert_to!(v) if v != link.version

    render(:nothing => true)
  end

  private

  def find_category
    category_id = params[:category_id]
    category_id = params[:link][:category_id] if category_id.nil? && !params[:link].nil?

    @category = Category.find_by_id(category_id) unless category_id.nil?
    if @category.nil?
      unless category_id.nil?  # Could not find the specified category
        redirect_to(root_path)
        return
      end
      add_breadcrumb(t('link_block.title_for_site'))
    else
      add_breadcrumb(t('category.categories'), categories_path)
      add_breadcrumb(@category.name, category_path(@category)) unless @category.nil?
      add_breadcrumb(t('link_block.title'))
    end
  end
end
