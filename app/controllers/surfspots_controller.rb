class SurfspotsController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :except => [ :index, :show, :search, :browse, :sessions, :photos ]
  before_filter :requires_admin, :only => [ :new, :create, :edit, :update, :destroy ]
  before_filter :setup_surfspot, :only => [ :show, :edit, :update, :destroy, :sessions, :photos ]
  before_filter :setup_side_content, :only => [:show, :sessions, :photos ]

  # GET /surfspots
  def index
    @title = "Index of all surfspots | Surftrottr"
    @surfspots = Surfspot.order("state, city, name")

    respond_to do |format|
      format.html
    end
  end

  # GET /surfspots/1
  def show
    @title = "Surf reports for #{@surfspot.full_name} | Surftrottr"
    #@tweets = MiddleMan.worker(:twit_worker).twitter_search(:arg => @surfspot)
    @reports = Report.paginate :page => params[:page], :per_page => 10,
	                           :conditions => "surfspot_id = #{@surfspot.id}",
							   :order => "actual_created_at DESC"
							   
    respond_to do |format|
      format.html
      ##format.mobile
    end
  end

  # GET /surfspots/new
  def new
    @title = "Create a new surfspot | Surftrottr"
    @surfspot = Surfspot.new

    respond_to do |format|
      format.html
    end
  end

  # GET /surfspots/1/edit
  def edit
    @title = "Edit a surfspot | Surftrottr"
  end

  # POST /surfspots
  def create
    @surfspot = Surfspot.new(params[:surfspot])

    respond_to do |format|
      if @surfspot.save
        format.html { redirect_to admin_path }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /surfspots/1
  def update
    respond_to do |format|
      if @surfspot.update_attributes(params[:surfspot])
        format.html { redirect_to admin_path }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /surfspots/1
  def destroy
    @surfspot.destroy

    respond_to do |format|
      format.html { redirect_to(surfspots_url) }
    end
  end

  # GET /surfspots/browse
  # Browse surfspots by state and city.
  def browse
    @title = "Browse surfspots | Surftrottr"
    @surfspots = Surfspot.order("state, city, name")

    respond_to do |format|
      format.html # browse.html.erb
      format.js
    end  
  end

  # GET /surfspots/search
  # Search for surfspots.
  def search
    @title = "Search surfspots | Surftrottr"

    #if not params[:commit].nil?
	#  @surfspots = Surfspot.geo_search(params)
	#elsif not params[:q].nil?
	if not params[:q].nil?
	  @surfspots = Surfspot.text_search(params[:q])
	end

    respond_to do |format|
      format.html # search.html.erb
    end  
  end
  
  # GET /surfspots/request
  # Suggest a new surfspot to be added to Surftrottr.
  def suggest
    @surfspot = flash[:suggested_surfspot] ? flash[:suggested_surfspot] : SuggestedSurfspot.new
	
    respond_to do |format|
      format.html # suggest.html.erb
      format.xml  { render :xml => @surfspots }
    end  
  end
  
  # GET /surfspots/:id/sessions
  def sessions
	@title = "Surf sessions for #{@surfspot.full_name} | Surftrottr"

    @sessions = SurfSession.paginate :page => params[:page], :per_page => 10,
	                                 :conditions => "surfspot_id = #{@surfspot.id}",
							         :order => "actual_date DESC"
							   
    respond_to do |format|
      format.html
      ##format.mobile
    end
  end
  
  # GET /surfspots/:id/photos
  def photos
    @title = "Photos for #{@surfspot.full_name} | Surftrottr"
    @photos = @surfspot.photos
    respond_to do |format|
      format.html
      ##format.mobile
    end
  end

  private

  # Retrieve the Surfspot object.
  def setup_surfspot
    begin
      @surfspot = Surfspot.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Surfspot does not exist."
      redirect_to_forwarding_url
    end
  end

  def setup_side_content
    # http://github.com/ewildgoose/ym4r_gm
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => false)
    @map.center_zoom_init([@surfspot.latitude, @surfspot.longitude], 13)
    @map.overlay_init(GMarker.new([@surfspot.latitude, @surfspot.longitude], :title => @surfspot.full_name, :info_window => @surfspot.full_name))

    # Find surfspots within a 10 miles range.
    @nearby_spots = Surfspot.geo_search(@surfspot, 20)

    @nearby_spots.each { |spot|
      marker = GMarker.new([spot.latitude, spot.longitude], :title => spot.full_name, :info_window => spot.full_name)
      @map.overlay_init(marker)
    }
  end
end
