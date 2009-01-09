class TagsController < ApplicationController
  before_filter :check_admin, :except => ['show']

  def show
    if mod[:category].nil? and params[:tag] != '*'
      redirect_to(root_path)
    else
      render(:text => '', :layout => 'application')
    end
  end

  # Admin ----------------------------------------------------------------------

  def index
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(params[:tag])
    if @tag.save
      redirect_to(tags_path)
    else
      render(:action => 'new')
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.update_attributes(params[:tag])
    if @tag.save
      redirect_to(tags_path)
    else
      render(:action => 'edit')
    end
  end

  def destroy
    Tag.destroy(params[:id])
    redirect_to(tags_path)
  end
end
