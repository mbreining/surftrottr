class EventController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication
  
  def delete
    event = Event.find_by_id(params[:id])
	event.destroy

    respond_to do |format|
	  format.html { redirect_to :controller => "surfer", :action => current_user.screen_name }
	  format.js do 
	    render :update do |page|
	      page.visual_effect :fade, "event_#{event.id}"
	    end
	  end
	end
  end
  
end
