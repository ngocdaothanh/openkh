class AdminPagesController < AdminController
  add_breadcrumb I18n.t('static.pages'), 'admin_pages_path'

  def index
    @pages = Page.tops
  end

  def show
    @page = Page.find(params[:id])
    add_breadcrumb(@page.title, admin_page_path(@page))
  end

  def new
    @page = Page.new
    add_breadcrumb(t('common.create'))
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to(admin_pages_path)
    else
      add_breadcrumb(t('common.create'))
      render(:action => 'new')
    end
  end

  def edit
    @page = Page.find(params[:id])
    add_breadcrumb(@page.title, admin_page_path(@page))
    add_breadcrumb(t('common.edit'))
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      redirect_to(admin_pages_path)
    else
      add_breadcrumb(@page.title, admin_page_path(@page))
      add_breadcrumb(t('common.edit'))
      render(:action => 'edit')
    end
  end

  def batch_update
    pages = params[:pages]
    pages.each do |id, attrs|
      page = Page.find(id)
      page.update_attributes(attrs)
    end

    flash[:notice] = t('static.pages_saved')
    redirect_to(admin_pages_path)
  end

  def destroy
    Page.destroy(params[:id])
    redirect_to(admin_pages_path)
  end
end
