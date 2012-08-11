class PostsController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :except => ['show']
  before_filter :setup_post, :only => [ 'show', 'edit', 'update', 'destroy' ]
  before_filter :requires_ownership, :only => [ 'edit', 'update', 'destroy' ]

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @title = "#{@post.title} | Surftrottr"
	
	if logged_in?
	  @hide_edit_links = (@post.user == current_user) ? false : true
	else
	  @hide_edit_links = true
	end

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @title = "New bulletin | Surftrottr"
    @post = Post.new
    @post.photos_attributes = Array.new(3, { :image => nil })

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /posts/1/edit
  def edit
    @title = "Edit your bulletin | Surftrottr"
	unless @post.photos.count == 3
	  @post.photos_attributes = Array.new(3 - @post.photos.length, { :image => nil })
    end
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
	@post.user_id = current_user.id
	@user = current_user

    respond_to do |format|
      if @user.posts << @post
		record_event
        flash[:notice] = 'Your bulletin has been successfully posted.'
        format.html { redirect_to surfer_bulletins_path(@user.screen_name) }
      else
	    @post.photos_attributes = Array.new(3 - @post.photos.length, { :image => nil })
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @user = current_user
    respond_to do |format|
      if @post.update_attributes(params[:post])
	    record_event
        flash[:notice] = 'Your bulletin has been successfully updated.'
        format.html { redirect_to(@post) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @user = current_user
    @post.delete

    respond_to do |format|
	  record_event
	  flash[:notice] = 'Your bulletin has been successfully removed.'
      format.html { redirect_to surfer_bulletins_path(@user.screen_name) }
    end
  end
  
  private
  
  # Retrieve the Post object.
  def setup_post
    begin
      @post = Post.find(params[:id])
	rescue ActiveRecord::RecordNotFound
	  flash[:error] = 'Bulletin does not exist.'
	  redirect_to_forwarding_url	  
	end
  end

  # Make sure that the current user owns the Post object.
  def requires_ownership
	unless @post.user == current_user
	  flash[:error] = 'Permission denied.'
	  redirect_to_forwarding_url
	end
  end
  
  def record_event
	action = params[:action]
	if action == "create"
      event = PostEvent.new(:user_id => @user.id,
							:post_id => @post.id,
						    :action => PostEvent::POST_ADDED)
	elsif action  == "update"
      event = PostEvent.new(:user_id => @user.id,
							:post_id => @post.id,
							:action => PostEvent::POST_EDITED)
	elsif action  == "destroy"
      event = PostEvent.new(:user_id => @user.id,
							:post_id => @post.id,
							:action => PostEvent::POST_DELETED)
	end
	@user.events << event
  end
end
