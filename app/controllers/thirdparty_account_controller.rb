class ThirdpartyAccountController < ApplicationController

  # List all twitter accounts.
  def index
    @title = "Twitter settings | Surftrottr"
    @user = current_user
    @accounts = @user.active_thirdparty_accounts
  end

  # Add a twitter account.
  def edit
    @title ="Edit your Twitter account(s) | Surftrottr"
    @user = current_user
    @accounts = @user.active_thirdparty_accounts
	
    if param_posted?(:thirdparty_account)
	    screen_name = params[:thirdparty_account][:src_screen_name]
	  
	    # Call Twitter API to retrieve the account info.
		twitter_user = Twitter.user(screen_name)
	  
	    @account = ThirdpartyAccount.find_by_thirdparty_name_and_src_screen_name(ThirdpartyAccount::TWITTER, screen_name)
	    if @account.nil?
		  # Account does not yet exist, create one.
	      @account = ThirdpartyAccount.new(:thirdparty_name => ThirdpartyAccount::TWITTER,
	                                       :src_user_id => twitter_user.id,
										   :src_screen_name => screen_name,
		 							       :src_avatar_url => twitter_user.profile_image_url)
	      if @user.thirdparty_accounts << @account
	        record_event
			flash[:notice] = "Your Twitter account has been successfully added!"
	        redirect_to :controller => "thirdparty_account", :action => "edit"
		  end
	    elsif !@account.is_active?
		  # Account exists in the database but is not active, reactivate it.
	      if @account.activate!
		      record_event
			  flash[:notice] = "Your Twitter account has been successfully added!"
		      redirect_to :controller => "thirdparty_account", :action => "edit"
		  end
	    else
	      # Account already exists, throw an error.
		  flash[:error] = "This Twitter account has already been added. Please try another one."
	    end
    end
  end
  
  # Delete a twitter account.
  # In reality we simply mark the account as inactive (:active => false).
  def delete
	@user = current_user
	account = ThirdpartyAccount.find_by_id(params[:id])
	account.disactivate!
	record_event
	redirect_to :controller => "thirdparty_account", :action => "edit" 
  end
  
  private
  
  def record_event
	action = params[:action]
	if action == "edit"
      event = ThirdpartyAccountEvent.new(:user_id => @user.id,
	                                       :thirdparty_account_id => @account.id,
	                                       :action => ThirdpartyAccountEvent::TWITTER_ACCOUNT_ADDED)
	elsif action  == "delete"
      event = ThirdpartyAccountEvent.new(:user_id => @user.id, 
	                                       :action => ThirdpartyAccountEvent::TWITTER_ACCOUNT_DELETED)
	end
    @user.events << event
  end

end
