class CategoriesController < ApplicationController
  add_breadcrumb I18n.t('category.categories'), 'categories_path'

  def index
  end

  # Category acts as a content filter.
  def show
    mod[:category] = Category.find_by_slug(params[:slug])
    if mod[:category].nil?
      flash[:notice] = t('category.not_found')
      redirect_to(root_path)
    else
      add_breadcrumb(mod[:category].name)
      render(:text => '', :layout => true)
    end
  end
end
