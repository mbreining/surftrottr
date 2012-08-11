class SurferController < ApplicationController
  include ApplicationHelper

  def show
    screen_name = params[:screen_name]
    @user = User.find_by_screen_name(screen_name)
	
    if @user
	  if @user.active
	    if logged_in? 
	        @hide_edit_links = true if @user.id != current_user.id
		else
		    @hide_edit_links = true
		end
      
	    @title = "Profile for #{screen_name} | Surftrottr"
        @user_information = @user.user_information || UserInformation.new
	    @surfspots = @user.surfspots
		@gears = @user.gears
		@surfboards = @user.surfboards
		@post = @user.posts.last
	    @events = Event.paginate :page => params[:page], :per_page => 20,
		  					     :conditions => "user_id = #{@user.id}",
							     :order => "created_at DESC"
	  else
        flash[:error] = "User '#{screen_name}' no longer exists!"
        redirect_to surfer_path(current_user.screen_name)
	  end
    else
      flash[:error] = "User '#{screen_name}' does not exist!"
      redirect_to surfer_path(current_user.screen_name)
    end
  end
end
