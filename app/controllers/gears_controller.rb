class GearsController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :except => ['show']
  before_filter :setup_gear, :only => [ 'show', 'edit', 'update', 'destroy' ]
  before_filter :requires_ownership, :only => [ 'edit', 'update', 'destroy' ]

  # GET /gears
  # GET /gears.xml
  def index
    @title = "Your surfing gear | Surftrottr"
	@gears = current_user.gears
  end

  # GET /gears/1
  # GET /gears/1.xml
  def show
	if logged_in?
	  @hide_edit_links = true if @gear.user.id != current_user.id
	else
	  @hide_edit_links = true
	end
      
	@title = "#{@gear.category.underscore.humanize + " - " + @gear.brand + " " + @gear.name} | Surftrottr"
  
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /gears/new
  # GET /gears/new.xml
  def new
    @title = "Add a new gear | Surftrottr"
    @gear = Gear.new
	@gear.photos_attributes = Array.new(3, { :image => nil })
	@user = current_user

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /gears/1/edit
  def edit
    @title = "Edit your gear | Surftrottr"
	unless @gear.photos.count == 3
	  @gear.photos_attributes = Array.new(3 - @gear.photos.count, { :image => nil })
    end
  end

  # POST /gears
  # POST /gears.xml
  def create
    @gear = Gear.new(params[:gear])
	@gear.user_id = current_user.id
	@user = current_user

    respond_to do |format|
      if @user.gears << @gear
        record_event
        flash[:notice] = "Your gear has been successfully added."
        format.html { redirect_to gears_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /gears/1
  # PUT /gears/1.xml
  def update
    respond_to do |format|
      if @gear.update_attributes(params[:gear])
	    record_event
        flash[:notice] = "Your gear has been successfully edited."
        format.html { redirect_to(@gear) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /gears/1
  # DELETE /gears/1.xml
  def destroy
    @gear.delete

    respond_to do |format|
	  record_event
	  flash[:notice] = "Your gear has been successfully removed."
      format.html { redirect_to(gears_url) }
    end
  end
  
  private
  
  # Retrieve the Gear object.
  def setup_gear
    begin
      @gear = Gear.find(params[:id])
	rescue ActiveRecord::RecordNotFound
	  flash[:error] = "Gear does not exist."
	  redirect_to_forwarding_url	  
	end
  end
  
  # Make sure that the current user owns the Gear object.
  def requires_ownership
	unless @gear.user == current_user
	  flash[:error] = "Permission denied."
	  redirect_to_forwarding_url
	end
  end
  
  def record_event
	action = params[:action]
	user = current_user
	if action == "create"
      event = GearEvent.new(:user_id => user.id,
							:gear_id => @gear.id,
							:action => GearEvent::GEAR_ADDED)
	elsif action  == "update"
      event = GearEvent.new(:user_id => user.id,
							:gear_id => @gear.id,
							:action => GearEvent::GEAR_EDITED)
	elsif action  == "destroy"
      event = GearEvent.new(:user_id => user.id,
	                        :gear_id => @gear.id,
							:action => GearEvent::GEAR_DELETED)
	end
    user.events << event
  end
end
