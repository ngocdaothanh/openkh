class CommentsController < ApplicationController
  layout nil  # All actions are Ajax

  before_filter :check_captcha, :only => [:create, :update]
  before_filter :check_login, :only => [:create, :edit, :update, :destroy]

  def index
    @comments_model_type = params[:model_type]
    @comments_model_id = params[:model_id]
    @comments = Comment.find(
      :all,
      :page       => {:current => params[:page]},
      :conditions => {:model_type => @comments_model_type, :model_id => @comments_model_id},
      :order      => 'created_at ASC')
  end

  def create
    comment = Comment.new(params[:comment])
    comment.user_id = mod[:me].id
    comment.ip      = request.remote_ip

    render(:update) do |page|
      if comment.save
        page['#comment_list'].append(render('comments/comment', :comment => comment))
        page << "OpenKH.editor('comment_message', 'comment[message]').setContent('');"
      else
        page.alert(comment.errors.full_messages.join("\n"))
      end
    end
  end

  def update
    # The textarea should not be reset on update failure, so that the user has
    # a chance to correct and update later

    render(:update) do |page|
      comment = Comment.find(params[:id])
      if comment.user_id != mod[:me].id
        @status = 400
        page.alert(t('comment.only_edit_own_comment'))
        break
      end

      comment.message = params[:comment][:message]
      comment.ip = request.remote_ip
      unless comment.save
        @status = 400
        page.alert(comment.errors.full_messages.join("\n"))
      end

      # Status code 200 is returned and the client can update properly
    end
  end

  def destroy
    render(:update) do |page|
      comment = Comment.find(params[:id])
      if comment.user_id != mod[:me].id
        @status = 400
        page.alert(t('comment.only_delete_own_comment'))
      else
        comment.destroy
        # Status code 200 is returned and the client can update properly
      end
    end
  end
end
