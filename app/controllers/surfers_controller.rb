class SurfersController < ApplicationController
  include ApplicationHelper
  
  # GET /surfers/search
  # Search for surfers.
  def search
    @title = "Search surfers | Surftrottr"

	if not params[:q].nil?
	  @surfers = User.text_search(params[:q])
	  user_infos = UserInformation.text_search(params[:q])
      @surfers.concat(user_infos.collect { |info| info.user }).uniq!
	end

    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @surfers }
    end  
  end
  
end