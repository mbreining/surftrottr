class FriendshipController < ApplicationController
  include ApplicationHelper
  before_filter :requires_authentication, :setup_friends
  
  def edit
    @user = current_user
  end
  
  # Send a friend request.
  # Note: 'request' as a method name is not allowed by Rails.
  def create
	Friendship.request(@user, @friend)

    UserMailer.friend_request(:user => @user,
                                      :friend => @friend,
  	  							      :user_url => surfer_url(@user.screen_name),
									  :accept_url => url_for(:action => "accept", :id => @user.screen_name),
									  :decline_url => url_for(:action => "decline", :id => @user.screen_name)).deliver
	  
	flash[:notice] = "Your request has been sent to #{@friend.screen_name}."
	redirect_to surfer_path(@friend.screen_name)
  end
  
  def accept
    if @user.requested_friends.include?(@friend)
      Friendship.accept(@user, @friend)
	  record_event
      flash[:notice] = "#{@friend.screen_name} is now your surf buddy!"
    else
      flash[:notice] = "There is no surf buddy request from #{@friend.screen_name}."
    end
    redirect_to :controller => "friendship", :action => "edit"
  end
  
  def decline
    if @user.requested_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "#{@friend.screen_name}'s surf buddy request has been declined."
    else
      flash[:notice] = "There is no surf buddy request from #{@friend.screen_name}."
    end
    redirect_to :controller => "friendship", :action => "edit"
  end
  
  def cancel
    if @user.pending_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Your surf buddy request has been canceled."
    else
      flash[:notice] = "There is no surf buddy request from #{@friend.screen_name}."
    end
    redirect_to :controller => "friendship", :action => "edit"
  end
  
  def delete
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
	  record_event
      flash[:notice] = "#{@friend.screen_name} is no longer your surf buddy."
    else
      flash[:notice] = "#{@friend.screen_name} is not your surf buddy!"
    end
    redirect_to :controller => "friendship", :action => "edit"
  end

  private 
  
  def setup_friends
    @user = current_user
	@friend = User.find_by_screen_name(params[:id])
  end
  
  def record_event
	action = params[:action]
	if action == "accept"
	  user_event = FriendshipEvent.new(:user_id => @user.id,
	                                   :friend_id => @friend.id,
							           :action => FriendshipEvent::FRIEND_ADDED)
	  friend_event = FriendshipEvent.new(:user_id => @friend.id,
	                                     :friend_id => @user.id,
							             :action => FriendshipEvent::FRIEND_ADDED)
	elsif action  == "delete"
	  user_event = FriendshipEvent.new(:user_id => @user.id,
	                                   :friend_id => @friend.id,
					                   :action => FriendshipEvent::FRIEND_DELETED)
	  friend_event = FriendshipEvent.new(:user_id => @friend.id,
	                                     :friend_id => @user.id,
					                     :action => FriendshipEvent::FRIEND_DELETED)
	end
	@user.events << user_event
	@friend.events << friend_event 
  end 

end
