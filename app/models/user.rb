# == Schema Information
#
# Table name: users
#
#  id                      :integer(4)      not null, primary key
#  active                  :boolean(1)      default(TRUE)
#  screen_name             :string(255)
#  email                   :string(255)
#  password                :string(255)
#  reason_for_deactivation :string(255)     default("")
#  created_at              :datetime
#  updated_at              :datetime
#  authorization_token     :string(255)
#  last_login              :datetime
#  logged_in               :boolean(1)      default(FALSE)
#  reputation              :integer(4)      default(0)
#

require 'digest/sha1'

class User < ActiveRecord::Base
  has_one :user_information
  accepts_nested_attributes_for :user_information, :allow_destroy => true
  has_many :thirdparty_accounts
  has_many :reports, :order => "actual_created_at DESC"
  has_many :favorites
  has_many :surfspots, :through => :favorites, :order => "state, city, name"
  has_many :suggested_surfspots
  has_many :events, :order => "created_at DESC"
  has_many :report_photos, :source => :photos, :through => :reports
  has_many :surf_session_photos, :source => :photos, :through => :surf_sessions
  has_many :user_roles
  has_many :roles, :through => :user_roles
  has_many :surf_sessions, :order => "actual_date DESC, created_at DESC"
  has_many :comments, :order => "created_at DESC", :dependent => :destroy
  has_many :friendships
  has_many :friends, :through => :friendships, :conditions => "status = 'accepted'", :order => :screen_name
  has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 'requested'"
  has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 'pending'"
  has_many :gears
  has_many :gear_photos, :source => :photos, :through => :gears
  has_many :surfboards
  has_many :surfboard_photos, :source => :photos, :through => :surfboards
  has_many :posts
  has_many :post_photos, :source => :photos, :through => :posts
  has_many :votes

  ##is_indexed :fields => ['screen_name']

  attr_accessor :remember_me
  attr_accessor :current_password
  
  # Max and min lengths for all fields
  SCREEN_NAME_MIN_LENGTH = 4
  SCREEN_NAME_MAX_LENGTH = 20
  PASSWORD_MIN_LENGTH = 4
  PASSWORD_MAX_LENGTH = 40
  EMAIL_MAX_LENGTH = 50
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
  
  # Text box sizes for display in the views 
  SCREEN_NAME_SIZE = 20 
  PASSWORD_SIZE = 10 
  EMAIL_SIZE = 30
  
  # Reasons for deactivating account
  SVC_NOT_USEFUL = "I don't find the service useful"
  NOT_ENOUGHT_REPORTS = "There are too few surf reports posted"
  SURFSPOTS_NOT_COVERED = "The surfspots I usually go to are not covered"
  BAD_PERFORMANCE = "The website is too slow"
  OTHER = "Other"

  validates_uniqueness_of :screen_name, :email
  validates_confirmation_of :password
  validates_length_of :screen_name, :within => SCREEN_NAME_RANGE
  validates_length_of :password, :within => PASSWORD_RANGE
  validates_length_of :email, :maximum => EMAIL_MAX_LENGTH
  validates_length_of :reason_for_deactivation, :maximum => Surftrottr::Application.config.db_string_max_length

  validates_format_of :screen_name,
                      :with => /^[A-Z0-9_]*$/i,
                      :message => "must contain only letters, numbers, and underscores"
  validates_format_of :email,
                      :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                      :message => "must be a valid email address"

  # Return the user full name.
  def full_name
    self.user_information.full_name
  end

  # Log a user in.
  def login!(session)
    session[:user_id] = self.id
	self.logged_in = true
	self.last_login = Time.now
	save!
  end
  
  # Log a user out.
  def self.logout!(session, cookies)
    session[:user_id] = nil
    cookies.delete(:authorization_token)
  end
  
  # Remember a user for future login,
  # i.e. sent back a cookie uniquely identifying the user.
  def remember!(cookies)
    cookie_expiration = 10.years.from_now
    cookies[:remember_me] = {:value => "1", :expires => cookie_expiration}
    self.authorization_token = unique_identifier
    save!
    cookies[:authorization_token] = {:value => self.authorization_token, :expires => cookie_expiration}
  end
  
  # Forget a user's login status,
  # i.e. make sure no cookies are sent back.
  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end
  
  # Return true if the user wants the login status remembered.
  def remember_me?
    self.remember_me == "1"
  end
  
  # Clear a user's password (typically to suppress its display in a view).
  def clear_password!
    self.password = nil
    self.password_confirmation = nil
    self.current_password = nil
  end
  
  # Return true if the password from params is correct.
  def correct_password?(params)
    current_password = params[:user][:current_password]
    password == current_password
  end
  
  # Generate messages for password errors.
  def password_errors(params)
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    valid?
    errors.add(:current_password, "is incorrect")
  end
  
  # Checks whether an email is valid or not.
  def self.is_email_valid?(email)
    email.match(/^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i)
  end
  
  # Cheks wether the user is active or not.
  def active?
    self.active
  end
  
  # Return the user avatar.
  def avatar
    Avatar.new(self)
  end
  
  # Check if the user has a given role.
  def has_role?(role)
    self.roles.count(:conditions => ["name = ?", role]) > 0
  end

  # Check if the user has admin role.
  def is_admin?
    self.has_role?("Admin")
  end

  # Add a role to the user.
  def add_role(role)
    return if self.has_role?(role)
    self.roles << Role.find_by_name(role)
  end
  
  # Return all user photos.
  def photos
    photos = self.report_photos + self.surf_session_photos + self.gear_photos + self.surfboard_photos + self.post_photos
	photos.sort! { |a, b|  b.created_at <=> a.created_at }
  end
  
  # Return a list of active thirdparty accounts.
  def active_thirdparty_accounts
    accounts = []
    self.thirdparty_accounts.each do |account|
	    if account.active?
	      accounts << account
	    end
	  end
    return accounts
  end
  
  # Return all standard reports.
  def standard_reports
    std_reports = []
    self.reports.each do |report|
      if report.class.to_s == Report::STANDARD_REPORT
        std_reports << report
      end
    end
    return std_reports
  end
  
  # Return all twitter reports.
  def twitter_reports
    twttr_reports = []
    self.reports.each do |report|
      if report.class.to_s == Report::TWITTER_REPORT
        twttr_reports << report
      end
    end
    return twttr_reports
  end
  
  # Perform a text search on a user.
  # Uses Sphinx under the covers.
  def self.text_search(q)
    search = Ultrasphinx::Search.new(:query => q, :class_names => 'User')
    search.run
    search.results
  end  
  
  # Add a new report.
  def add_report(report)
    User.transaction do
      self.reports << report
	  self.update_attributes! :reputation => self.reputation + 2
	end
  end

  private 
  
  def unique_identifier
    Digest::SHA1.hexdigest("#{self.screen_name}:#{self.password}")
  end
end

