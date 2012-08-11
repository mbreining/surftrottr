# == Schema Information
#
# Table name: reports
#
#  id                    :integer(4)      not null, primary key
#  type                  :string(255)
#  surfspot_id           :integer(4)      not null
#  user_id               :integer(4)      not null
#  text                  :text
#  actual_created_at     :datetime
#  surf_conditions       :string(255)
#  advanced_only         :boolean(1)
#  wave_height           :string(255)
#  wind_direction        :string(255)
#  wind_speed            :string(255)
#  paddle_out            :string(255)
#  crowd_factor          :string(255)
#  thirdparty_account_id :integer(4)
#  src_id                :integer(8)
#  created_at            :datetime
#  updated_at            :datetime
#  source                :string(255)     default("web")
#  score                 :integer(4)      default(0)
#

class Report < ActiveRecord::Base
  belongs_to :surfspot
  belongs_to :user
  has_many :photos
  accepts_nested_attributes_for :photos, :allow_destroy => true
  has_many :comments, :as => :commentable, :order => "created_at", :dependent => :destroy
  has_many :votes

  ##is_indexed :fields => ['text', 'created_at'],
  ##           :include => [{:association_name => 'user', :field => 'screen_name'},
  ##           {:association_name => 'surfspot', :field => 'name'}]

  STANDARD_REPORT = 'StandardReport'
  TWITTER_REPORT = 'TwitterReport'

  WEB = 'Web'
  MOBILE_WEB = 'MobileWeb'
  TEXT = 'Text'
  TWITTERRIFIC = 'Twitterrific'

  validates_presence_of :surfspot_id, :user_id
  validates_length_of :text, :maximum => Surftrottr::Application.config.db_string_max_length

  # Votes up this report.
  def vote_up(voter)
    vote = Vote.new(:report_id => self.id, :user_id => voter.id, :value => 1)
    Report.transaction do
      vote.save!
      self.update_attributes! :score => self.score + 1
      self.user.update_attributes! :reputation => self.user.reputation + 10
    end
  end

  # Votes down this report.
  def vote_down(voter)
	vote = Vote.new(:report_id => self.id, :user_id => voter.id, :value => 1)
	Report.transaction do
	  vote.save!
	  self.update_attributes! :score => self.score - 1
	  self.user.update_attributes! :reputation => self.user.reputation - 2
	end
  end
  
  # Has a given user already voted on this report?
  def has_user_voted?(user)
    Vote.find_by_report_id_and_user_id(id, user.id)
  end

  # Indicates if this is a good report (score > 0)
  def is_good?
    return score > 0
  end

  # Indicates if this is a poor report (score < 0 and voters > 1)
  def is_poor?
    if score < 0
      votes = Vote.where("report_id = #{id}")
      return true if votes.count > 1
    end
    false
  end
end

