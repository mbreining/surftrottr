class SiteController < ApplicationController
  before_filter :requires_admin, :only => [ :admin ]
  ##has_mobile_fu

  def index
    @title = "Surftrottr | Simple real-time surf reports"
	  user_agent = request.user_agent.to_s.downcase
	  if logged_in? 
	    redirect_to :controller => "surfer", :action => current_user.screen_name
	    return
	  end
	  if request.get?
	    if flash[:user].nil?
		  @user = User.new(:remember_me => remember_me_string)
		else
	      # flash[:user] could have been set by a failed login (see account_controller)
	      @user = flash[:user]
		end
		respond_to do |format|
          format.html { render :layout => "welcome" }
          ##format.mobile { render :layout => "welcome" }
        end
	  elsif param_posted?(:user)
		flash[:user] = params[:user]
	    redirect_to :controller => "account", :action => "login"
	  end
  end

  def faq
    @title = "Frequently asked questions | Surftrottr"
  end

  def about
    @title = "About | Surftrottr"
  end

  def terms
	@title = "Terms of Use | Surftrottr"
  end
  
  def contact
	@title = "Contact us | Surftrottr"
	if param_posted?(:message)
	  @message = Message.new(params[:message])
	  if @message.valid?
	    if logged_in?
        UserMailer.to_surftrottr(:user => current_user,
                                 :message => @message).deliver
		else
        UserMailer.to_surftrottr(:user => nil,
                                 :message => @message).deliver
		end
		flash[:notice] = "Thanks for your inquiry. Your email has been sent."
		redirect_to :controller => "home", :action => "index"
      else
    flash[:error] = "Your email is not valid. Please check its length."
      end
    end
  end

  def admin
    @title = "Admin front-end | Surftrottr"
    @users = User.where([ "last_login > ?", 5.days.ago ])
    @surfspots = Surfspot.all
    @suggested_surfspots = SuggestedSurfspot.where({ :processed => false })
  end

  # GET /site/search
  def search
    @title = "Search | Surftrottr"

	unless params[:q].nil?
	  @entries = search_entries(params[:q], params[:page])
	  #surf_sessions = SurfSession.text_search(params[:q])
	  #@entries = reports + surf_sessions
	  #@entries = @entries.sort_by { |entry| entry.created_at }
	  #@entries.reverse!
	  #@entries = reports
	end

    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @report }
    end  
  end
  
  private
  
  # Perform a text search on reports and surf sessions.
  # Uses Sphinx under the covers.
  def search_entries(q, page)
    search = Ultrasphinx::Search.new(:query => q, 
	                                 :page => page.nil? ? 1 : page,
									 :per_page => 15,
									 :sort_mode => 'descending',
                                     :sort_by => 'created_at',
									 :class_names => ['Report', 'SurfSession', 'Post', 'Gear', 'Surfboard'])
    search.run
  end
  
end
