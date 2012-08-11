class FavoriteController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :setup
  
  # Add a favorite surfspot for a given user.
  def add
    Favorite.add(@user, @surfspot)
	record_event
   
	respond_to do |format|
	  format.html { redirect_to surfspot_path(@surfspot) }
	  format.js do
	    render :update do |page|
		  page.hide "favorite"
		end
	  end
	end
  end
  
  # Delete a favorite surfspot for a given user.
  def delete
    @surfspot = Surfspot.find_by_id(params[:id])
    Favorite.remove(@user, @surfspot)
	record_event
	redirect_to :controller => "favorite", :action => "edit"
  end

  # Edit the list of favorite surfspots for a given user.
  def edit
    @title = "Edit your list of favorite surfspots | Surftrottr"
    @user = User.find(session[:user_id])
  end
  
  private
  
  def setup
    @user = User.find(session[:user_id])
	if params[:id]
	  @surfspot = Surfspot.find_by_id(params[:id])
	end
  end 
  
  def record_event
	action = params[:action]
	if action == "add"
	  event = FavoriteEvent.new(:user_id => @user.id,
	                            :surfspot_id => @surfspot.id,
							    :action => FavoriteEvent::FAVORITE_SURFSPOT_ADDED)
	elsif action  == "delete"
	  event = FavoriteEvent.new(:user_id => @user.id,
	                            :surfspot_id => @surfspot.id,
					            :action => FavoriteEvent::FAVORITE_SURFSPOT_DELETED)
	end
	@user.events << event    
  end 
end
