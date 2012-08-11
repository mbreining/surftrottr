class SurfboardsController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :except => ['show']
  before_filter :setup_surfboard, :only => [ 'show', 'edit', 'update', 'destroy' ]
  before_filter :requires_ownership, :only => [ 'edit', 'update', 'destroy' ]

  # GET /surfboards
  # GET /surfboards.xml
  def index
    @title = "Your surfboards | Surftrottr"
	@surfboards = current_user.surfboards
  end

  # GET /surfboards/1
  # GET /surfboards/1.xml
  def show
	if logged_in?
	  @hide_edit_links = true if @surfboard.user.id != current_user.id
	else
	  @hide_edit_links = true
	end
      
	@title = "#{@surfboard.category.underscore.humanize + " - " + @surfboard.length + " " + @surfboard.brand} | Surftrottr"
  
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /surfboards/new
  # GET /surfboards/new.xml
  def new
    @title = "Add a new surfboard | Surftrottr"
    @surfboard = Surfboard.new
	@surfboard.photos_attributes = Array.new(3, { :image => nil })
	@user = current_user

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /surfboards/1/edit
  def edit
    @title = "Edit your surfboard | Surftrottr"
	unless @surfboard.photos.count == 3
	  @surfboard.photos_attributes = Array.new(3 - @surfboard.photos.count, { :image => nil })
    end
  end

  # POST /surfboards
  # POST /surfboards.xml
  def create
    @surfboard = Surfboard.new(params[:surfboard])
	@surfboard.user_id = current_user.id
	@user = current_user

    respond_to do |format|
      if @user.surfboards << @surfboard
        record_event
        flash[:notice] = "Your surfboard has been successfully added."
        format.html { redirect_to surfboards_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /surfboards/1
  # PUT /surfboards/1.xml
  def update
    respond_to do |format|
      if @surfboard.update_attributes(params[:surfboard])
	    record_event
        flash[:notice] = "Your surfboard has been successfully edited."
        format.html { redirect_to(@surfboard) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /surfboards/1
  # DELETE /surfboards/1.xml
  def destroy
    @surfboard.delete

    respond_to do |format|
	  record_event
	  flash[:notice] = "Your surfboard has been successfully removed."
      format.html { redirect_to(surfboards_url) }
    end
  end
  
  private
  
  # Retrieve the Surfboard object.
  def setup_surfboard
    begin
      @surfboard = Surfboard.find(params[:id])
	rescue ActiveRecord::RecordNotFound
	  flash[:error] = "Surfboard does not exist."
	  redirect_to_forwarding_url	  
	end
  end
  
  # Make sure that the current user owns the Surfboard object.
  def requires_ownership
	unless @surfboard.user == current_user
	  flash[:error] = "Permission denied."
	  redirect_to_forwarding_url
	end
  end
  
  def record_event
	action = params[:action]
	user = current_user
	if action == "create"
      event = SurfboardEvent.new(:user_id => user.id,
							     :surfboard_id => @surfboard.id,
							     :action => SurfboardEvent::SURFBOARD_ADDED)
	elsif action  == "update"
      event = SurfboardEvent.new(:user_id => user.id,
							     :surfboard_id => @surfboard.id,
							     :action => SurfboardEvent::SURFBOARD_EDITED)
	elsif action  == "destroy"
      event = SurfboardEvent.new(:user_id => user.id,
	                             :surfboard_id => @surfboard.id,
							     :action => SurfboardEvent::SURFBOARD_DELETED)
	end
    user.events << event
  end
end
