class EmailController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :only => ["correspond"]

  # Send a reminder email to a user who forgot his screen name and/or password. 
  def remind
    @title = "Forgot your password? | Surftrottr"
	
	if param_posted?(:user)
	  user = User.find_by_email(params[:user][:email])
	  if user
	    UserMailer.reminder(user).deliver
		flash[:notice] = "Your login information has been sent. Please check your email."
	  elsif
        flash[:error] = "There is no user registered with that email address. Please enter the email address registered with your Surftrottr account."
	  end
    end
  end
  
  def correspond
    @recipient = User.find_by_screen_name(params[:id])
    @title = "Email #{@recipient.screen_name}"

	if param_posted?(:message)
	  @message = Message.new(params[:message])
	  if @message.valid?
	    UserMailer.note(:user => current_user,
                         :recipient => @recipient,
								   :message => @message,
								   :user_url => surfer_url(current_user.screen_name),
								   :reply_url => url_for(:action => "correspond", :id => current_user.screen_name)).deliver
		flash[:notice] = "Your email has been sent."
		redirect_to surfer_path(@recipient.screen_name)
      else
	    flash[:error] = "Your email is not valid. Please check its length."
	  end
	end
  end
  
end
