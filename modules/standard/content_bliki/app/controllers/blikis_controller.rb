class BlikisController < ApplicationController
  layout 'application', :except => [:version, :diff]

  before_filter :check_login,   :only => [:create, :edit, :update, :revert]
  before_filter :check_captcha, :only => [:create, :update, :revert]

  def create
    @bliki = Bliki.new(params[:bliki])
    @bliki.user_id = mod[:me].id
    @bliki.ip      = request.remote_ip
    if @bliki.save
      redirect_to(bliki_path(@bliki))
    else
      add_breadcrumb(t('bliki.name'), blikis_path)
      add_breadcrumb(t('common.create'))
      render(:action => 'new')
    end
  end

  # Only let normal user change name and body.
  def edit
    @bliki = Bliki.find(params[:id])
    unless params[:version].nil?
      v = params[:version].to_i
      @bliki.revert_to(v) if v != @bliki.version
    end
    content_add_breadcrumb(@bliki)
    add_breadcrumb(t('common.edit'))
  end

  def update
    @bliki = Bliki.find(params[:id])

    # Avoid mass assignment for security

    @bliki.title        = params[:bliki][:title]
    @bliki.introduction = params[:bliki][:introduction]
    @bliki.body         = params[:bliki][:body]

    # Mountpoints
    @bliki.category_ids = params[:bliki][:category_ids]
    @bliki.tag_list     = params[:bliki][:tag_list]

    now = Time.now
    if mod[:me].id == @bliki.user_id
      @bliki.created_at = now  # Increase the last modification time
      saved = @bliki.save_without_revision

      # We must manually update version DB
      if saved
        v = BlikiVersion.find(:first, :conditions => {
          :bliki_id => @bliki.id,
          :version  => @bliki.version})
        v.title        = @bliki.title
        v.introduction = @bliki.introduction
        v.body         = @bliki.body
        v.created_at   = now
        v.save
      end
    else
      @bliki.user_id    = mod[:me].id
      @bliki.ip         = request.remote_ip
      @bliki.created_at = now  # Creation time of the new version
      saved = @bliki.save
    end

    if saved
      redirect_to(bliki_path(@bliki))
    else
      content_add_breadcrumb(@bliki)
      add_breadcrumb(t('common.edit'))
      render(:action => 'edit')
    end
  end

  # Ajax. Display a version.
  def version
    v = params[:version].to_i
    @bliki = Bliki.find(params[:id])
    @effective_version = @bliki.version
    @bliki.revert_to(version) if v != @effective_version
  end

  # Ajax.
  def diff
    @bliki = Bliki.find(params[:id])

    v1 = params[:v1].to_i
    @bliki.revert_to(v1) if @bliki.version != v1
    v1 = "#{@bliki.introduction}#{@bliki.body}"

    v2 = params[:v2].to_i
    @bliki.revert_to(v2)
    v2 = "#{@bliki.introduction}#{@bliki.body}"

    @diff = HTMLDiff.diff(v1, v2)
  end

  # Ajax.
  def revert
    v = params[:version].to_i
    bliki = Bliki.find(params[:id])

    # updated_at is automatically updated
    bliki.revert_to!(version) if v != bliki.version

    render(:nothing => true)
  end
end
