class ReportsController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :except => [ 'show', 'yes', 'no' ]
  before_filter :setup_report, :only => [ 'show', 'destroy', 'yes', 'no' ]
  before_filter :requires_admin, :only => [ :destroy ]

  # GET /reports/1
  def show
    @title = "#{@report.surfspot.full_name} surf report | Surftrottr"
    respond_to do |format|
      format.html
    end
  end

  # GET /reports/new
  def new
    @title = "Post a new report | Surftrottr"
    @report = StandardReport.new
    @report.photos << Photo.new
    @surfspots = Surfspot.all
    @surfspot = Surfspot.find(params[:surfspot_id]) if params[:surfspot_id]
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /reports
  def create
    @report = StandardReport.new(params[:standard_report])
    @user = current_user
    @report.user_id = @user.id
    @report.actual_created_at = Time.now
    ##@report.source = is_mobile_device? ? Report::MOBILE_WEB : Report::WEB
    @report.source = Report::WEB
    @surfspot = @report.surfspot

    respond_to do |format|
      if @report.valid?
        @user.add_report @report
        record_event
        flash[:notice] = 'Your surf report has been successfully posted.'
        format.html { redirect_to surfspot_url(:id => @surfspot) }
        ##format.mobile { redirect_to surfspot_url(:id => @surfspot) }
        format.js do
          render :update do |page|
            page.visual_effect :blind_up, "new_report"
            page.replace_html "reports", :partial => "reports/report", :collection => @surfspot.reports, :locals => { :hide_surfer => false, :hide_surfspot => true, :photo_size => "thumb" }
            page.visual_effect :highlight, "report_#{@report.id}", :duration => 2
          end
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  # DELETE /reports/1
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to(reports_url) }
      format.xml  { head :ok }
    end
  end

  # GET
  def yes
    if logged_in?
      if @report.user_id == current_user.id
        respond_to do |format|
          format.js { render :template => "reports/not_authorized.rjs" }
        end
      else
        if current_user.reputation >= 15
          @report.vote_up(current_user)
          record_event
          respond_to do |format|
            format.js { render :template => "reports/vote.rjs" }
          end
        else
          respond_to do |format|
            format.js { render :template => "reports/need_15_reputation.rjs" }
          end
        end
      end
    else
      respond_to do |format|
        format.js { render :template => "reports/login_first.rjs" }
      end
    end
  end

  # GET
  def no
    if logged_in?
      if @report.user_id == current_user.id
	    respond_to do |format|
	      format.js { render :template => "reports/not_authorized.rjs" }
	    end
	  else
	    if current_user.reputation >= 50
	      @report.vote_down(current_user)
          record_event
	      respond_to do |format|
	        format.js { render :template => "reports/vote.rjs" }
	      end
		else
	      respond_to do |format|
	        format.js { render :template => "reports/need_50_reputation.rjs" }
	      end
		end
	  end
	else
	  respond_to do |format|
	    format.js { render :template => "reports/login_first.rjs" }
	  end
	end
  end

  private

  # Retrieve the Report object.
  def setup_report
    begin
      @report = Report.find(params[:id])
	rescue ActiveRecord::RecordNotFound
	  flash[:error] = 'Report does not exist.'
	  redirect_to_forwarding_url	  
	end
  end

  def record_event
	action = params[:action]
	if action == "create"
	  event = ReportEvent.new(:user_id => current_user.id, :surfspot_id => @surfspot.id, :report_id => @report.id, :action => ReportEvent::STANDARD_REPORT_POSTED)
	elsif action == "yes"
	  event = ReportEvent.new(:user_id => current_user.id, :surfspot_id => @report.surfspot, :report_id => @report.id, :action => ReportEvent::REPORT_VOTED_UP)
	elsif action == "no"
	  event = ReportEvent.new(:user_id => current_user.id, :surfspot_id => @report.surfspot, :report_id => @report.id, :action => ReportEvent::REPORT_VOTED_DOWN)
	end
	current_user.events << event
  end
end
