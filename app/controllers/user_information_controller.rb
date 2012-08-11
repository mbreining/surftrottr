class UserInformationController < ApplicationController
  include ApplicationHelper

  def index
    redirect_to :controller => "user", :action => "index"
  end

  def edit
    @title = "Edit your personal information | Surftrottr"
    @user = current_user
    @user.user_information ||= UserInformation.new
    @user_information = @user.user_information
    if param_posted?(:user_information)
      if @user_information.update_attributes(params[:user_information])
	    record_event
	    redirect_to :controller => "surfer", :action => "#{@user.screen_name}"
      end
    end
  end
  
  private
  
  def record_event
    event = UserInformationEvent.new(:user_id => @user.id)
	@user.events << event
  end
end
