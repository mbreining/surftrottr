class SuggestedSurfspotsController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication
  
  # POST /suggested_surfspots
  # POST /suggested_surfspots.xml
  def create
    @surfspot = SuggestedSurfspot.new(params[:suggested_surfspot])
	@surfspot.user_id = current_user.id

    respond_to do |format|
      if @surfspot.save
	    flash[:notice] = "Your suggestion has been successfully submitted. We will look at it ASAP. Thank you!"
        format.html { redirect_to :controller => "surfspots", :action => "suggest" }
        format.xml  { render :xml => @surfspot, :status => :created, :location => @surfspot }
	  else
	    flash[:suggested_surfspot] = @surfspot
        format.html { redirect_to :controller => "surfspots", :action => "suggest" }
        format.xml  { render :xml => @surfspot.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /suggested_surfspots/archive/1
  # PUT /suggested_surfspots/archive/1.xml
  # Mark a suggested_surfspot as processed.
  def archive
    @surfspot = SuggestedSurfspot.find(params[:id])
debugger
    respond_to do |format|
	debugger
      if @surfspot.archive!
	    flash[:notice] = "The suggested surfspot '#{@surfspot.full_name}' has been successfully archived."
        format.html { redirect_to admin_path }
        format.xml  { head :ok }
      else
	    flash[:error] = "An error occurred while archiving the suggested surfspot."
        format.html { redirect_to admin_path }
        format.xml  { render :xml => @surfspot.errors, :status => :unprocessable_entity }
      end
    end 
  end
  
end
