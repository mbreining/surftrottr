class SurfSessionsController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :except => ['show']
  before_filter :setup_surf_session, :only => [ 'show', 'edit', 'update', 'destroy' ]
  before_filter :requires_ownership, :only => [ 'edit', 'update', 'destroy' ]
  
  # GET /surf_sessions/1
  # GET /surf_sessions/1.xml
  def show
    @title = "#{@surf_session.user.screen_name}'s surf session at #{@surf_session.surfspot.full_name} | Surftrottr"
	
	if logged_in?
	  @hide_edit_links = (@surf_session.user == current_user) ? false : true
	else
	  @hide_edit_links = true
	end
	
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /surf_sessions/new
  # GET /surf_sessions/new.xml
  def new
    @title = "New surf session | Surftrottr"
    @surf_session = SurfSession.new
	@surfspots = Surfspot.all
    @surf_session.photos_attributes = Array.new(3, { :image => nil })
	@surfboards = current_user.surfboards

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /surf_sessions/1/edit
  def edit
    @title = "Edit your surf session | Surftrottr"
	@surfspots = Surfspot.all
	@surfboards = current_user.surfboards
	unless @surf_session.photos.count == 3
	  @surf_session.photos_attributes = Array.new(3 - @surf_session.photos.length, { :image => nil })
    end
  end

  # POST /surf_sessions
  # POST /surf_sessions.xml
  def create
    @surf_session = SurfSession.new(params[:surf_session])
	@surf_session.user_id = current_user.id
	@user = current_user
	
    respond_to do |format|
      if @user.surf_sessions << @surf_session
	    @surf_session.actual_date ||= @surf_session.created_at
        @surf_session.save
        record_event
        flash[:notice] = 'Your surf session has been successfully added.'
        format.html { redirect_to surfer_sessions_path(@user.screen_name) }
      else
	    @surfspots = Surfspot.all
		@surf_session.photos_attributes = Array.new(3 - @surf_session.photos.length, { :image => nil })
		@surfboards = current_user.surfboards
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /surf_sessions/1
  # PUT /surf_sessions/1.xml
  def update
    @user = current_user
    respond_to do |format|
	  actual_date = @surf_session.actual_date
      if @surf_session.update_attributes(params[:surf_session])
	    # Reset the actual date to its stored value
	    @surf_session.actual_date = actual_date
		@surf_session.save

	    record_event
        flash[:notice] = 'Your surf session has been successfully updated.'
        format.html { redirect_to(@surf_session) }
      else
	    @surfspots = Surfspot.all
	    @surfboards = current_user.surfboards
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /surf_sessions/1
  # DELETE /surf_sessions/1.xml
  def destroy
    @user = current_user
    @surf_session.delete

    respond_to do |format|
	  record_event
	  flash[:notice] = "Your surf session has been successfully removed."
      format.html { redirect_to surfer_sessions_path(@user.screen_name) }
    end
  end

  private

  # Retrieve the SurfSession object.
  def setup_surf_session
    begin
      @surf_session = SurfSession.find(params[:id])
	rescue ActiveRecord::RecordNotFound
	  flash[:error] = "Surf session does not exist."
	  redirect_to_forwarding_url	  
	end
  end

  # Make sure that the current user owns the SurfSession object.
  def requires_ownership
	unless @surf_session.user == current_user
	  flash[:error] = "Permission denied."
	  redirect_to_forwarding_url
	end
  end

  def record_event
	action = params[:action]
	if action == "create"
      event = SurfSessionEvent.new(:user_id => @user.id,
							       :surf_session_id => @surf_session.id,
								   :surfspot_id => @surf_session.surfspot_id,
							       :action => SurfSessionEvent::SURF_SESSION_ADDED)
	elsif action  == "update"
      event = SurfSessionEvent.new(:user_id => @user.id,
							       :surf_session_id => @surf_session.id,
								   :surfspot_id => @surf_session.surfspot_id,
							       :action => SurfSessionEvent::SURF_SESSION_EDITED)
	elsif action  == "destroy"
      event = SurfSessionEvent.new(:user_id => @user.id,
	                               :surf_session_id => @surf_session.id,
								   :surfspot_id => @surf_session.surfspot_id,
							       :action => SurfSessionEvent::SURF_SESSION_DELETED)
	end
	@user.events << event
  end
end
