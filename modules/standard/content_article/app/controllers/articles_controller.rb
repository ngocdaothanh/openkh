class ArticlesController < ApplicationController
  layout 'application', :except => [:version, :diff]

  before_filter :check_login,   :only => [:create, :edit, :update, :revert]
  before_filter :check_captcha, :only => [:create, :update, :revert]

  def create
    @article = Article.new(params[:article])
    @article.user_id = mod[:me].id
    @article.ip      = request.remote_ip
    if @article.save
      redirect_to(article_path(@article))
    else
      add_breadcrumb(t('article.name'), articles_path)
      add_breadcrumb(t('common.create'))
      render(:action => 'new')
    end
  end

  # Only let normal user change name and body.
  def edit
    @article = Article.find(params[:id])
    unless params[:version].nil?
      v = params[:version].to_i
      @article.revert_to(v) if v != @article.version
    end
    content_add_breadcrumb(@article)
    add_breadcrumb(t('common.edit'))
  end

  def update
    @article = Article.find(params[:id])

    # Avoid mass assignment for security

    @article.title        = params[:article][:title]
    @article.introduction = params[:article][:introduction]
    @article.body         = params[:article][:body]

    # Mountpoints
    @article.category_ids = params[:article][:category_ids]
    @article.tag_list     = params[:article][:tag_list]

    now = Time.now
    if mod[:me].id == @article.user_id
      @article.created_at = now  # Increase the last modification time
      saved = @article.save_without_revision

      # We must manually update version DB
      if saved
        v = ArticleVersion.find(:first, :conditions => {
          :article_id => @article.id,
          :version  => @article.version})
        v.title        = @article.title
        v.introduction = @article.introduction
        v.body         = @article.body
        v.created_at   = now
        v.save
      end
    else
      @article.user_id    = mod[:me].id
      @article.ip         = request.remote_ip
      @article.created_at = now  # Creation time of the new version
      saved = @article.save
    end

    if saved
      redirect_to(article_path(@article))
    else
      content_add_breadcrumb(@article)
      add_breadcrumb(t('common.edit'))
      render(:action => 'edit')
    end
  end

  # Ajax. Display a version.
  def version
    v = params[:version].to_i
    @article = Article.find(params[:id])
    @effective_version = @article.version
    @article.revert_to(version) if v != @effective_version
  end

  # Ajax.
  def diff
    @article = Article.find(params[:id])

    v1 = params[:v1].to_i
    @article.revert_to(v1) if @article.version != v1
    v1 = "#{@article.introduction}#{@article.body}"

    v2 = params[:v2].to_i
    @article.revert_to(v2)
    v2 = "#{@article.introduction}#{@article.body}"

    @diff = HTMLDiff.diff(v1, v2)
  end

  # Ajax.
  def revert
    v = params[:version].to_i
    article = Article.find(params[:id])

    # updated_at is automatically updated
    article.revert_to!(version) if v != article.version

    render(:nothing => true)
  end
end
