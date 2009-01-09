class PagesController < ApplicationController
  add_breadcrumb I18n.t('static.pages'), 'pages_path'

  def index
    @pages = Page.tops
  end

  def show
    @page = Page.find_by_slug(params[:slug])
    if @page.nil?
      flash[:notice] = t('static.page_not_found')
      redirect_to(root_path)
    end
    add_breadcrumb(@page.title)
  end
end
