class AdminConfsController < AdminController
  add_breadcrumb I18n.t('admin.configurations'), 'admin_confs_path'

  before_filter :find_conf, :only => [:edit, :update]

  def index
    @classes = Conf.subclasses.sort_by { |c| t("#{c.to_s.underscore}.title") }
  end

  def edit
  end

  def update
    if @conf.update_attributes(params[@conf.class.to_s.underscore])
      flash[:notice] = t('admin.configuration_saved')
      redirect_to(admin_confs_path)
    else
      render(:action => 'edit')
    end
  end

  private

  def find_conf
    @conf = Conf.find(params[:id])
    add_breadcrumb(t("#{@conf.class.to_s.underscore}.title"))
  end
end
