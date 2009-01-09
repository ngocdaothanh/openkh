class EventsController < ApplicationController
  before_filter :check_login,   :only => [:create, :edit, :update, :join, :unjoin]
  before_filter :check_captcha, :only => [:create, :update, :join]
  before_filter :check_user,    :only => [:edit, :update]

  def create
    @event = Event.new(params[:event])
    @event.user_id = mod[:me].id
    @event.ip      = request.remote_ip
    if @event.save
      redirect_to(event_path(@event))
    else
      add_breadcrumb(t('event.name'), events_path)
      add_breadcrumb(t('common.create'))
      render(:action => 'new')
    end
  end

  # Only let the original author to edit.
  def edit
    # @event has been prepared in check_user
    content_add_breadcrumb(@event)
    add_breadcrumb(t('common.edit'))
  end

  # Only let the original author to update.
  def update
    # @event has been prepared in check_user

    # Avoid mass assignment for security

    @event.title        = params[:event][:title]
    @event.introduction = params[:event][:introduction]
    @event.instruction  = params[:event][:instruction]

    # Mountpoints
    @event.category_ids = params[:event][:category_ids]
    @event.tag_list     = params[:event][:tag_list]

    if @event.save
      redirect_to(event_path(@event))
    else
      content_add_breadcrumb(@event)
      add_breadcrumb(t('common.edit'))
      render(:action => 'edit')
    end
  end

  def join
    event = Event.find(params[:id])
    event.join(mod[:me], params[:note])
    redirect_to(event_path(event))
  end

  def unjoin
    event = Event.find(params[:id])
    event.unjoin(mod[:me])
    redirect_to(event_path(event))
  end

  private

  def check_user
    @event = Event.find(params[:id])
    if @event.user_id != mod[:me].id
      flash[:notice] = t('content_event.not_original_author')
      redirect_to(event_path(@event))
    end
  end
end
