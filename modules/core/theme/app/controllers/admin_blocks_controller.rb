class AdminBlocksController < AdminController
  add_breadcrumb I18n.t('theme.blocks'), 'admin_blocks_path'

  before_filter :new_block,  :only => [:new, :create]
  before_filter :edit_block, :only => [:edit, :update]

  def index
    @unassigneds = Block.unassigneds.sort_by { |b| t("#{b.class.to_s.underscore}.title") }
    @classes = Block.subclasses.sort_by { |c| t("#{c.to_s.underscore}.title") }
  end

  def new
  end

  # Save/update all blocks.
  def create
    if @block.save
      flash[:notice] = t('theme.blocks_saved')
      redirect_to(admin_blocks_path)
    else
      render(:action => 'new')
    end
  end

  def edit
  end

  def update
    if @block.update_attributes(params[@block.class.to_s.underscore])
      flash[:notice] = t('theme.blocks_saved')
      redirect_to(admin_blocks_path)
    else
      render(:action => 'edit')
    end
  end

  def destroy
    Block.destroy(params[:id])
    redirect_to(admin_blocks_path)
  end

  def batch_update
    confs = params[:blocks]
    confs.each do |id, attrs|
      block = Block.find(id)
      block.update_attributes(attrs)
    end
    flash[:notice] = t('theme.blocks_saved')
    redirect_to(admin_blocks_path)
  end

  private

  def new_block
    type = params[:type]
    klass = type.constantize
    @block = klass.new(params[klass.to_s.underscore])
    title = t("#{type.underscore}.title")
    add_breadcrumb(t('theme.create_new_block', :block => title))
  end

  def edit_block
    @block = Block.find(params[:id])
    title = t("#{@block.class.to_s.underscore}.title")
    add_breadcrumb(t('theme.edit_block', :block => title))
  end
end
