class AdminCategoriesController < AdminController
  add_breadcrumb I18n.t('category.categories'), 'admin_categories_path'

  def index
  end

  def new
    @category = Category.new
    add_breadcrumb(t('common.create'))
  end

  def create
    @category = Category.new(params[:category])

    if @category.save
      flash[:notice] = t('category.saved')
      redirect_to(admin_categories_path)
    else
      add_breadcrumb(t('common.create'))
      render(:action => 'new')
    end
  end

  def batch_update
    categories = params[:categories]
    categories.each do |id, attrs|
      cat = Category.find(id)
      cat.update_attributes(attrs)
    end

    flash[:notice] = t('category.saved')
    redirect_to(admin_categories_path)
  end

  def destroy
    Category.destroy(params[:id])
    redirect_to(admin_categories_path)
  end
end
