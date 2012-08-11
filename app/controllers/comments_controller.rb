class CommentsController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :only => [ 'show', 'create' ]
  
  def show
    comment = Comment.find(params[:id])

	if comment.commentable_type == Comment::REPORT
	  redirect_to report_path(comment.commentable_id)
	elsif comment.commentable_type == Comment::SURF_SESSION
	  redirect_to surf_session_path(comment.commentable_id)
	elsif comment.commentable_type == Comment::GEAR
	  redirect_to gear_path(comment.commentable_id)
	elsif comment.commentable_type == Comment::SURFBOARD
	  redirect_to surfboard_path(comment.commentable_id)
	elsif comment.commentable_type == Comment::POST
	  redirect_to post_path(comment.commentable_id)
	end
  end
  
  def new
	@comment = Comment.new if logged_in?
	
	if params[:report_id]
	  @report = Report.find(params[:report_id])
	  commentable = @report
	elsif params[:surf_session_id]
	  @surf_session = SurfSession.find(params[:surf_session_id])
	  commentable = @surf_session
	elsif params[:gear_id]
	  @gear = Gear.find(params[:gear_id])
	  commentable = @gear
	elsif params[:surfboard_id]
	  @surfboard = Surfboard.find(params[:surfboard_id])
	  commentable = @surfboard
	elsif params[:post_id]
	  @post = Post.find(params[:post_id])
	  commentable = @post
	end
	
	respond_to do |format|
	  format.js do
	    render :update do |page|
		  if not logged_in?
		    page.replace_html "message_#{commentable.id}", :partial => "comments/login_first"
		  end
		  
		  page.replace_html "comments_for_commentable_#{commentable.id}",
							:partial => "comments/comment",
							:collection => commentable.comments
							
		  if logged_in?
		    page.replace_html "new_comment_form_for_commentable_#{commentable.id}", :partial => "new"
		  end
		end
	  end
	end
  end
  
  def create
    @comment = Comment.new(params[:comment])
	if params[:report_id]
	  @report = Report.find(params[:report_id])
	  commentable = @report
	elsif params[:surf_session_id]
	  @surf_session = SurfSession.find(params[:surf_session_id])
	  commentable = @surf_session
	elsif params[:gear_id]
	  @gear = Gear.find(params[:gear_id])
	  commentable = @gear
	elsif params[:surfboard_id]
	  @surfboard = Surfboard.find(params[:surfboard_id])
	  commentable = @surfboard
	elsif params[:post_id]
	  @post = Post.find(params[:post_id])
	  commentable = @post
	end
	@comment.user = current_user
	@comment.commentable = commentable
	
	respond_to do |format|
	  if commentable.comments << @comment
	    unless @comment.user.id == commentable.user_id
	      UserMailer.new_comment(:user => @comment.user,
                               :owner => User.find(commentable.user_id),
  	  							         :user_url => surfer_url(@comment.user.screen_name),
									     :commentable_type => @comment.commentable_type,
									     :commentable_url => url_for(:controller => "comments", :action => "show", :id => @comment.id)).deliver
		end
	    record_event
	    format.js do
		  render :update do |page|
		    page.replace_html "comments_for_commentable_#{commentable.id}",
			                  :partial => "comments/comment",
							  :collection => commentable.comments
			page.hide "new_comment_form_for_commentable_#{commentable.id}"
		  end
		end
	  else
	    format.js { render :nothing => true }
	  end
	end
  end
  
  private
  
  def record_event
	if params[:report_id]
      event = CommentEvent.new(:user_id => @comment.user.id,
	                           :comment_id => @comment.id,
							   :report_id => @comment.commentable.id,
							   :action => CommentEvent::COMMENT_ADDED)
	elsif params[:surf_session_id]
      event = CommentEvent.new(:user_id => @comment.user.id,
	                           :comment_id => @comment.id,
							   :surf_session_id => @comment.commentable.id,
							   :action => CommentEvent::COMMENT_ADDED)
	elsif params[:gear_id]
      event = CommentEvent.new(:user_id => @comment.user.id,
	                           :comment_id => @comment.id,
							   :gear_id => @comment.commentable.id,
							   :action => CommentEvent::COMMENT_ADDED)
	elsif params[:surfboard_id]
      event = CommentEvent.new(:user_id => @comment.user.id,
	                           :comment_id => @comment.id,
							   :surfboard_id => @comment.commentable.id,
							   :action => CommentEvent::COMMENT_ADDED)
	elsif params[:post_id]
      event = CommentEvent.new(:user_id => @comment.user.id,
	                           :comment_id => @comment.id,
							   :post_id => @comment.commentable.id,
							   :action => CommentEvent::COMMENT_ADDED)
	end

	@comment.user.events << event
  end
  
end
