class HomeController < ApplicationController
  def index
    @title = "Recent bulletins | Surftrottr"
    @comments = Comment.order("created_at DESC").limit(10)
    users = User.all
    @top_bloggers = users.sort { |a, b| b.posts.length <=> a.posts.length }
    @top_reporters = users.sort { |a, b| b.reports.length <=> a.reports.length }
    @top_loggers = users.sort { |a, b| b.surf_sessions.length <=> a.surf_sessions.length }
    @new_members = User.order("created_at DESC").limit(7)
    @active_members = User.where("logged_in = true")
    @posts = Post.paginate :page => params[:page],
                           :per_page => 15,
                           :order => "created_at DESC"
  end

  def reports
    @title = "Recent surf reports | Surftrottr"
    @comments = Comment.order("created_at DESC").limit(10)
    users = User.all
    @top_bloggers = users.sort { |a, b| b.posts.length <=> a.posts.length }
    @top_reporters = users.sort { |a, b| b.reports.length <=> a.reports.length }
    @top_loggers = users.sort { |a, b| b.surf_sessions.length <=> a.surf_sessions.length }
    @new_members = User.order("created_at DESC").limit(7)
    @active_members = User.where("logged_in = true")
    @reports = Report.paginate :page => params[:page],
                               :per_page => 15,
                               :order => "actual_created_at DESC"
  end

  def sessions
    @title = "Recent surf sessions | Surftrottr"
    @comments = Comment.order("created_at DESC").limit(10)
    users = User.all
    @top_bloggers = users.sort { |a, b| b.posts.length <=> a.posts.length }
    @top_reporters = users.sort { |a, b| b.reports.length <=> a.reports.length }
    @top_loggers = users.sort { |a, b| b.surf_sessions.length <=> a.surf_sessions.length }
    @new_members = User.order("created_at DESC").limit(7)
    @active_members = User.where("logged_in = true")
    @surf_sessions = SurfSession.paginate :page => params[:page],
                                          :per_page => 15,
                                          :order => "created_at DESC"
  end
end
