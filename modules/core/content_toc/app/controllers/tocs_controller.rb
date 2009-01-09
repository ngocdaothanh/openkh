class TocsController < ApplicationController
  def create
    @toc = Toc.new(params[:toc])
    @toc.user_id = mod[:me].id
    @toc.ip      = request.remote_ip
    if @toc.save
      redirect_to(toc_path(:id => @toc.to_param))
    else
      add_breadcrumb(t('toc.name'), tocs_path)
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
    content_add_breadcrumb(@toc)
    add_breadcrumb(t('common.edit'))
  end

  def update
    @toc = Toc.find(params[:id])

    # Avoid mass assignment for security

    @toc.title             = params[:toc][:title]
    @toc.introduction      = params[:toc][:introduction]
    @toc.table_of_contents = params[:toc][:table_of_contents]

    # Mountpoints
    @toc.category_ids = params[:toc][:category_ids]
    @toc.tag_list     = params[:toc][:tag_list]

    now = Time.now
    if mod[:me].id == @toc.user_id
      @toc.created_at = now  # Increase the last modification time
      saved = @toc.save_without_revision

      # We must manually update version DB
      if saved
        v = TocVersion.find(:first, :conditions => {
          :toc_id => @toc.id,
          :version => @toc.version})
        v.title             = @toc.title
        v.introduction      = @toc.introduction
        v.table_of_contents = @toc.table_of_contents
        v.created_at        = now
        v.save
      end
    else
      @toc.user_id    = mod[:me].id
      @toc.ip         = request.remote_ip
      @toc.created_at = now  # Creation time of the new version
      saved = @toc.save
    end

    if saved
      redirect_to(toc_path(@toc))
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
    v1 = "#{@toc.introduction}#{@toc.table_of_contents}"

    v2 = params[:v2].to_i
    @toc.revert_to(v2)
    v2 = "#{@toc.introduction}#{@toc.table_of_contents}"

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
end
