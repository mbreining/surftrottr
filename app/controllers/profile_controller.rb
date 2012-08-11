class ProfileController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :only => [ 'stats' ]
  
  def bulletins
    screen_name = params[:screen_name]
    @user = User.find_by_screen_name(params[:screen_name])
	
    unless @user.nil? || !@user.active?
	    if logged_in?
		  @hide_edit_links, @hide_actions = true, true if @user.id != current_user.id
		else
		  @hide_edit_links, @hide_actions = true, true
		end
      
	    @title = "#{screen_name}'s bulletins | Surftrottr"
        @user_information = @user.user_information || UserInformation.new
	    @surfspots = @user.surfspots
		@gears = @user.gears
		@surfboards = @user.surfboards
		@post = @user.posts.last
		@posts = Post.paginate :page => params[:page], :per_page => 10,
                                              :conditions => "user_id = #{@user.id}",
	   		    			                  :order => "created_at DESC"
    else
      flash[:error] = "User '#{screen_name}' does not exists!"
	  redirect_to_forwarding_url
    end
  end
  
  def reports
    screen_name = params[:screen_name]
    @user = User.find_by_screen_name(params[:screen_name])
	
    unless @user.nil? || !@user.active?
	    if logged_in? 
		  @hide_edit_links = true if @user.id != current_user.id
		else
		  @hide_edit_links = true
		end
      
	    @title = "#{screen_name}'s reports | Surftrottr"
        @user_information = @user.user_information || UserInformation.new
	    @surfspots = @user.surfspots
		@gears = @user.gears
		@surfboards = @user.surfboards
		@post = @user.posts.last
        @reports = Report.paginate :page => params[:page], :per_page => 10,
                                   :conditions => "user_id = #{@user.id}",
	   		    			       :order => "actual_created_at DESC"
    else
      flash[:error] = "User '#{screen_name}' does not exists!"
	  redirect_to_forwarding_url
    end
  end
  
  def sessions
    screen_name = params[:screen_name]
    @user = User.find_by_screen_name(params[:screen_name])
	
    unless @user.nil? || !@user.active?
	    if logged_in?
		  @hide_edit_links, @hide_actions = true, true if @user.id != current_user.id
		else
		  @hide_edit_links, @hide_actions = true, true
		end
      
	    @title = "#{screen_name}'s surf sessions | Surftrottr"
        @user_information = @user.user_information || UserInformation.new
	    @surfspots = @user.surfspots
		@gears = @user.gears
		@surfboards = @user.surfboards
		@post = @user.posts.last
		@surf_sessions = SurfSession.paginate :page => params[:page], :per_page => 10,
                                              :conditions => "user_id = #{@user.id}",
	   		    			                  :order => "actual_date DESC, created_at DESC"
    else
      flash[:error] = "User '#{screen_name}' does not exists!"
	  redirect_to_forwarding_url
    end
  end

  def photos
    screen_name = params[:screen_name]
    @user = User.find_by_screen_name(params[:screen_name])
	
    unless @user.nil? || !@user.active?
	    if logged_in? 
		  @hide_edit_links = true if @user.id != current_user.id
		else
		  @hide_edit_links = true
		end
      
	    @title = "#{screen_name}'s photos | Surftrottr"
        @user_information = @user.user_information || UserInformation.new
	    @surfspots = @user.surfspots
		@gears = @user.gears
		@surfboards = @user.surfboards
		@post = @user.posts.last
		@photos = @user.photos
    else
      flash[:error] = "User '#{screen_name}' does not exists!"
	  redirect_to_forwarding_url
    end
  end
  
  def stats
	screen_name = params[:screen_name]
    @title = "#{screen_name}'s stats | Surftrottr"
    @user = User.find_by_screen_name(screen_name)

	posts_current_month = Post.find_by_sql ["SELECT p.id FROM posts p WHERE p.user_id = ? AND YEAR(p.created_at) = ? AND MONTH(p.created_at) = ?", @user.id, Time.now.year, Time.now.month]
	posts_current_month_minus_one = Post.find_by_sql ["SELECT p.id FROM posts p WHERE p.user_id = ? AND YEAR(p.created_at) = ? AND MONTH(p.created_at) = ?", @user.id, one_month_ago.year, one_month_ago.month]
 	posts_current_month_minus_two = Post.find_by_sql ["SELECT p.id FROM posts p WHERE p.user_id = ? AND YEAR(p.created_at) = ? AND MONTH(p.created_at) = ?", @user.id, two_months_ago.year, two_months_ago.month]
	
	sessions_current_month = SurfSession.find_by_sql ["SELECT s.id FROM surf_sessions s WHERE s.user_id = ? AND YEAR(s.created_at) = ? AND MONTH(s.created_at) = ?", @user.id, Time.now.year, Time.now.month]
	sessions_current_month_minus_one = SurfSession.find_by_sql ["SELECT s.id FROM surf_sessions s WHERE s.user_id = ? AND YEAR(s.created_at) = ? AND MONTH(s.created_at) = ?", @user.id, one_month_ago.year, one_month_ago.month]
 	sessions_current_month_minus_two = SurfSession.find_by_sql ["SELECT s.id FROM surf_sessions s WHERE s.user_id = ? AND YEAR(s.created_at) = ? AND MONTH(s.created_at) = ?", @user.id, two_months_ago.year, two_months_ago.month]
	
	reports_current_month = Report.find_by_sql ["SELECT r.id FROM reports r WHERE r.user_id = ? AND YEAR(r.created_at) = ? AND MONTH(r.created_at) = ?", @user.id, Time.now.year, Time.now.month]
	reports_current_month_minus_one = Report.find_by_sql ["SELECT r.id FROM reports r WHERE r.user_id = ? AND YEAR(r.created_at) = ? AND MONTH(r.created_at) = ?", @user.id, one_month_ago.year, one_month_ago.month]
 	reports_current_month_minus_two = Report.find_by_sql ["SELECT r.id FROM reports r WHERE r.user_id = ? AND YEAR(r.created_at) = ? AND MONTH(r.created_at) = ?", @user.id, two_months_ago.year, two_months_ago.month]

    photos_current_month = []
	photos_current_month_minus_one = []
	photos_current_month_minus_two = []
    @user.photos.each do |photo|
	    if photo.created_at.year == Time.now.year && photo.created_at.month == Time.now.month
		  photos_current_month << photo
		elsif photo.created_at.year == one_month_ago.year && photo.created_at.month == one_month_ago.month
		  photos_current_month_minus_one << photo
		elsif photo.created_at.year == two_months_ago.year && photo.created_at.month == two_months_ago.month
		  photos_current_month_minus_two << photo
		end
	end
	
	comments_current_month = Comment.find_by_sql ["SELECT c.id FROM comments c WHERE c.user_id = ? AND YEAR(c.created_at) = ? AND MONTH(c.created_at) = ?", @user.id, Time.now.year, Time.now.month]
    comments_current_month_minus_one = Comment.find_by_sql ["SELECT c.id FROM comments c WHERE c.user_id = ? AND YEAR(c.created_at) = ? AND MONTH(c.created_at) = ?", @user.id, one_month_ago.year, one_month_ago.month]
 	comments_current_month_minus_two = Comment.find_by_sql ["SELECT c.id FROM comments c WHERE c.user_id = ? AND YEAR(c.created_at) = ? AND MONTH(c.created_at) = ?", @user.id, two_months_ago.year, two_months_ago.month]

	current_month = Time.now.strftime("%b %y")
    current_month_minus_one = one_month_ago.strftime("%b %y")
    current_month_minus_two = two_months_ago.strftime("%b %y")
	
	@multi_bar_data = [[[current_month_minus_two, posts_current_month_minus_two.length], [current_month_minus_one, posts_current_month_minus_one.length], [current_month, posts_current_month.length]],
	                   [[current_month_minus_two, sessions_current_month_minus_two.length], [current_month_minus_one, sessions_current_month_minus_one.length], [current_month, sessions_current_month.length]],
					   [[current_month_minus_two, reports_current_month_minus_two.length], [current_month_minus_one, reports_current_month_minus_one.length], [current_month, reports_current_month.length]],
					   [[current_month_minus_two, photos_current_month_minus_two.length], [current_month_minus_one, photos_current_month_minus_one.length], [current_month, photos_current_month.length]],
					   [[current_month_minus_two, comments_current_month_minus_two.length], [current_month_minus_one, comments_current_month_minus_one.length], [current_month, comments_current_month.length]]]
  end
  
  private
  
  def one_month_ago
    if Time.now.month == 1
	  Time.mktime(Time.now.year - 1, 12, Time.now.day)
	else
	  Time.mktime(Time.now.year, Time.now.month - 1, Time.now.day)
	end
  end
  
  def two_months_ago
    if Time.now.month == 1
	  Time.mktime(Time.now.year - 1, 11, Time.now.day)
	elsif Time.now.month == 2
	  Time.mktime(Time.now.year - 1, 12, Time.now.day)
	else
	  Time.mktime(Time.now.year, Time.now.month - 1, Time.now.day)
	end
  end
  
end
