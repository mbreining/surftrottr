require 'twitter'

class TwitWorker < BackgrounDRb::MetaWorker
  SURFTROTTR_TWITTER_ACCOUNT = "surftrottr"

  set_worker_name :twit_worker
  def create(args = nil)
    # This method is called, when worker is loaded for the first time
	
	Surfspot.find(:all).each do |spot|
	  add_periodic_timer(60) { twitter_search(spot) }
	end
  end
  
  def twitter_search(spot)
    # Retrieve the last report for this surfspot.
    #last_report = TwitterReport.find(:first,
	#                                 :conditions => { :surfspot_id => spot.id },
	#						         :order => "actual_created_at DESC")
    
	begin
	
	  begin
	  
	    # Invoke the Twitter search API.
        #if last_report
	    #  begin
        #    tweets = Twitter::Search.new.to(TwitWorker::SURFTROTTR_TWITTER_ACCOUNT).hashed(spot.tag).since(last_report.src_id).fetch().results
	    #  rescue Crack::ParseError => error
		    # If the since_id is too old, the above Twitter API call may return an HTTP 404 (not found). 
		#    puts Time.now
	    #    puts error.message
		#    tweets = Twitter::Search.new.to(TwitWorker::SURFTROTTR_TWITTER_ACCOUNT).hashed(spot.tag).fetch().results
	    #  end
        #else
	      tweets = Twitter::Search.new.to(TwitWorker::SURFTROTTR_TWITTER_ACCOUNT).hashed(spot.tag).fetch().results
	    #end
		
	  rescue Twitter::General => error
	    puts Time.now
	    puts error.message
	    puts error.data.inspect
	  end
	
	  tweets.each do |tweet|	  
	    # Ensure that the tweet was sent from a Twitter account registered in Surftrottr.
	    # We should probably use the user_id instead of the user screen name here.
	    # There's a bug in Twitter though that prevents us from doing that for now ( http://code.google.com/p/twitter-api/issues/detail?id=214 ).
	    account = ThirdpartyAccount.find_by_thirdparty_name_and_src_screen_name(ThirdpartyAccount::TWITTER,
	                                                                            tweet.from_user)
	    if account && account.is_active?  
		  user = account.user
		
		  # Ensure that the tweet does not already exists.
	      unless Report.exists?(:thirdparty_account_id => account.id, :src_id => tweet.id)
			filtered_text = tweet.text.gsub("@" + TwitWorker::SURFTROTTR_TWITTER_ACCOUNT + " ", "").gsub(/[ ]?\##{spot.tag}[ ]?/, "")
	        
			# There are other types of sources (e.g. TwitterFon, bit.ly, FriendFeed, etc)
			# but for now we don't care about these (they will default to Report::WEB).
			if (tweet.source =~ /&gt;web&lt;/)
			  source = Report::WEB
			elsif (tweet.source =~ /&gt;txt&lt;/)
			  source = Report::TEXT
			elsif (tweet.source =~ /&gt;mobile web&lt;/)
			  source = Report::MOBILE_WEB
			elsif (tweet.source =~ /&gt;Twitterrific&lt;/)
			  source = Report::TWITTERRIFIC
			else
			  source = Report::UNKNOWN
			end
			
			report = TwitterReport.new(:surfspot_id => spot.id,
			  						   :user_id => user.id, 
		                               :text => filtered_text,
									   :actual_created_at => tweet.created_at,
									   :thirdparty_account_id => account.id,
	                                   :src_id => tweet.id,
									   :source => source)
									 
	        report.save
		    record_event(user, spot, report)
		  end
	    end
	  end
	  
	rescue StandardError => error
	  puts Time.now
	  puts error.message
	end

  end
    
  private
  
  def record_event(user, surfspot, report)
	event = ReportEvent.new(:user_id => user.id, 
	                        :surfspot_id => surfspot.id,
							:report_id => report.id,
							:action => ReportEvent::TWITTER_REPORT_POSTED)
	user.events << event
  end
end

