class AccountController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :only => [:index, :logout, :edit, :deactivate]
  
  def index 
    @user = current_user
    @title = "Settings for #{@user.screen_name} | Surftrottr"
  end

  def register
    @title = "Register | Surftrottr"
    @user = User.new
    @user.user_information = UserInformation.new
    if param_posted?(:user)
    @user.attributes = params[:user]
    if verify_recaptcha
        if @user.save
          @user.login!(session)
          UserMailer.registration_confirmation(@user).deliver
          redirect_to_forwarding_url
        else
          @user.clear_password!
        end
	  else
	    @user.errors.add_to_base("The security test failed")
	    @user.clear_password!
	  end
    end
  end

  def login
    # The login box is on the home page.
    # The login credentials are passed to the account controller using the flash memory.
	if User.is_email_valid?(flash[:user][:screen_name])
	  user_to_login = User.new(:screen_name => flash[:user][:screen_name],
	                           :email => flash[:user][:screen_name],
	                           :password => flash[:user][:password],
							   :remember_me => flash[:user][:remember_me])
	  user = User.find_by_email_and_password(user_to_login.email, user_to_login.password)
	else
	  user_to_login = User.new(flash[:user])
	  user = User.find_by_screen_name_and_password(user_to_login.screen_name, user_to_login.password)
	end
	
    if user && user.active
      user.login!(session)
      user_to_login.remember_me? ? user.remember!(cookies) : user.forget!(cookies)
      redirect_to_forwarding_url
    else
      # Don't show the password in the view.
      user_to_login.clear_password!
	  flash[:user] = user_to_login
      flash[:error] = "Invalid user name/password combination."
      redirect_to :controller => "site", :action => "index"
    end 
  end
  
  def logout
    @title = "Logout"
	current_user.update_attribute(:logged_in, false)
    User.logout!(session, cookies)
    redirect_to :action => "index", :controller => "site"
  end
  
  # Edit the user information.
  def edit
    @title = "Edit your account | Surftrottr"
    @user = current_user
    if param_posted?(:user)
      attribute = params[:attribute]
      case attribute
      when "email"
        try_to_update @user, attribute
        record_event
      when "password"
        if @user.correct_password?(params)
          try_to_update @user, attribute
          record_event
        else
          @user.password_errors(params)
        end
      end
    end
    # For security purposes, never fill in password fields.
    @user.clear_password!
  end
  
  # Deactivate a user account.
  def deactivate
    @title = "Deactivate your account | Surftrottr"
	
    @user = current_user
    if param_posted?(:user)
	  @user.active = false
	  @user.update_attributes(params[:user])
	  User.logout!(session, cookies)
	  redirect_to :action => "index", :controller => "site"
	end
  end
  
  private 
  
  # Try to update the user, redirecting if successful.
  def try_to_update(user, attribute)
    if user.update_attributes(params[:user])
      redirect_to :action => "index"
    end 
  end
  
  def record_event
  event = AccountEvent.new(:user_id => @user.id)
  @user.events << event
  end
end
