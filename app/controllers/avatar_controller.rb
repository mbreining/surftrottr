class AvatarController < ApplicationController
  before_filter :requires_authentication

  def index
	@user = User.find(session[:user_id])
    redirect_to :controller => "surfer", :action => "#{@user.screen_name}"
  end

  # Upload a new picture.
  def upload
    @title = "Upload a profile picture | Surftrottr"
	@user = User.find(session[:user_id])
	if param_posted?(:avatar)
	  image = params[:avatar][:image]
	  @avatar = Avatar.new(@user, image)
	  if @avatar.save
	    record_event
		redirect_to :controller => "surfer", :action => "#{@user.screen_name}"
	  end
	end
  end

  # Delete the current picture.
  def delete
	@user = User.find(session[:user_id])
	@user.avatar.delete
	record_event
	redirect_to :controller => "surfer", :action => "#{@user.screen_name}" 
  end

  private
  
  def record_event
	action = params[:action]
	if action == "upload"
	  event = AvatarEvent.new(:user_id => @user.id,
							  :action => AvatarEvent::PICTURE_UPLOADED)
	elsif action  == "delete"
	  event = AvatarEvent.new(:user_id => @user.id,
					    :action => AvatarEvent::PICTURE_DELETED)
	end
	@user.events << event    
  end
end
