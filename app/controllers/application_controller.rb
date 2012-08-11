require 'twitter'

class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper :all # include all helpers, all the time
  before_filter :check_authorization_cookie, :check_user_agent

  ##protect_from_forgery

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery :secret => 'de51d45fe0a3bccc0bc29553cb2fca42'

  # Pick a unique cookine name to distinguish our session data from others.
  #session :session_key => '_surftrottr_session_id'

  # Check for a valid authorization cookie, possibly logging the user in.
  def check_authorization_cookie
    authorization_token = cookies[:authorization_token]
    if authorization_token and not logged_in?
      user = User.find_by_authorization_token(authorization_token)
      user.login!(session) if user
    end
  end

  # Check the user agent and return an error message if IE is used.
  def check_user_agent
    if request.headers['User-Agent'] =~ /MSIE/
      flash[:permanent] = "This site does not support Internet Explorer. Please use Mozilla, Safari or Chrome." 
    end
  end

  # Protect a page from unauthenticated access.
  def requires_authentication
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:error] = "Please login or register first."
      redirect_to :controller => "site", :action => "index"
      return false
    end
  end

  # Restrict access to users with admin role only.
  def requires_admin
    unless current_user.is_admin?
      redirect_to_forwarding_url
      return false
    end
  end

  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(symbol)
    request.post? and params[symbol]
  end

  # Redirect to the previously requested URL (if present).
  def redirect_to_forwarding_url
    if (redirect_url = session[:protected_page])
      session[:protected_page] = nil
      redirect_to redirect_url
    else
      redirect_to :controller => "home", :action => "index"
    end
  end

  # Return a string with the status of the remember me checkbox.
  def remember_me_string
    cookies[:remember_me] || "0"
  end

  # Returns either true or false depending on whether or not the user agent of
  # the device making the request is matched to a device in our regex.
  def is_mobile_device?
    request.user_agent.to_s.downcase =~ Regexp.new(ActionController::MobileFu::MOBILE_USER_AGENTS)
  end
end
