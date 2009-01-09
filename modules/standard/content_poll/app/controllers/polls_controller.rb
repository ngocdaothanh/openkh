class PollsController < ApplicationController
  before_filter :check_login,   :only => [:create, :update]
  before_filter :check_captcha, :only => [:create]

  def create
    @poll = Poll.new(params[:poll])
    @poll.user_id = mod[:me].id
    @poll.ip      = request.remote_ip
    if @poll.save
      redirect_to(poll_path(@poll))
    else
      render(:action => 'new')
    end
  end

  # Vote.
  def update
    @poll = Poll.find(params[:id])
    @poll.vote(mod[:me], params[:ioption].to_i)
    redirect_to(poll_path(@poll))
  end
end
