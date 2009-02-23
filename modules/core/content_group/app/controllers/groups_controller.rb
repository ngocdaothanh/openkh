class GroupsController < ApplicationController
  before_filter :check_login,   :only => [:create, :edit, :update, :revert]
  before_filter :check_captcha, :only => [:create, :update, :revert]

  def create
    @group = Group.new(params[:group])
    @group.user_id = mod[:me].id
    if @group.save
      redirect_to(group_path(:id => @group.to_param))
    else
      add_breadcrumb(t('group.name'), groups_path)
      add_breadcrumb(t('common.create'))
      render(:action => 'new')
    end
  end

  def edit
    @group = Group.find(params[:id])
    unless params[:version].nil?
      v = params[:version].to_i
      @group.revert_to(v) if v != @group.version
    end
    content_add_breadcrumb(@group)
    add_breadcrumb(t('common.edit'))
  end

  def update
    @group = Group.find(params[:id])

    # Avoid mass assignment for security

    @group.title        = params[:group][:title]
    @group.introduction = params[:group][:introduction]
    @group.links        = params[:group][:links]

    # Mountpoints
    @group.category_ids = params[:group][:category_ids]
    @group.tag_list     = params[:group][:tag_list]

    now = Time.now
    if mod[:me].id == @group.user_id
      @group.created_at = now  # Increase the last modification time
      saved = @group.save_without_revision

      # We must manually update version DB
      if saved
        v = GroupVersion.find(:first, :conditions => {
          :group_id => @group.id,
          :version => @group.version})
        v.title        = @group.title
        v.introduction = @group.introduction
        v.links        = @group.links
        v.created_at   = now
        v.save
      end
    else
      @group.user_id    = mod[:me].id
      @group.created_at = now  # Creation time of the new version
      saved = @group.save
    end

    if saved
      redirect_to(group_path(@group))
    else
      content_add_breadcrumb(@group)
      add_breadcrumb(t('common.edit'))
      render(:action => 'edit')
    end
  end

  # Ajax. Display a version.
  def version
    v = params[:version].to_i
    @group = Group.find(params[:id])
    @effective_version = @group.version
    @group.revert_to(v) if v != @effective_version
  end

  # Ajax.
  def diff
    @group = Group.find(params[:id])

    v1 = params[:v1].to_i
    @group.revert_to(v1) if @group.version != v1
    v1 = "#{@group.introduction}#{@group.links}"

    v2 = params[:v2].to_i
    @group.revert_to(v2)
    v2 = "#{@group.introduction}#{@group.links}"

    @diff = HTMLDiff.diff(v1, v2)
  end

  # Ajax.
  def revert
    v = params[:version].to_i
    group = Group.find(params[:id])

    # updated_at is automatically updated
    group.revert_to!(v) if v != group.version

    render(:nothing => true)
  end
end
