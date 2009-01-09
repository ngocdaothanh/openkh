class QasController < ApplicationController
  # Although there is only one action in this controller, do not remove these
  # lines because when we add new actions in future versions, we know that maybe
  # we should add those actions to these lines
  before_filter :check_login,   :only => [:create]
  before_filter :check_captcha, :only => [:create]

  def create
    add_breadcrumb(t('qa.name'), qas_path)
    add_breadcrumb(t('common.create'))

    @qa = Qa.new(params[:qa])
    @qa.user_id = mod[:me].id
    @qa.ip      = request.remote_ip
    if @qa.save
      redirect_to(qa_path(@qa.to_param))
    else
      render(:action => 'new')
    end
  end
end
