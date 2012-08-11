# == Schema Information
#
# Table name: surf_sessions
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)      not null
#  surfspot_id     :integer(4)
#  rating          :integer(4)      not null
#  surf_conditions :string(255)
#  wave_height     :string(255)
#  crowd_factor    :string(255)
#  text            :text
#  actual_date     :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  surfboard_id    :integer(4)
#  embed_link      :text
#

class SurfSession < ActiveRecord::Base
  belongs_to :surfspot
  belongs_to :user
  belongs_to :surfboard
  has_many :photos
  accepts_nested_attributes_for :photos, :allow_destroy => true
  has_many :comments, :as => :commentable, :order => "created_at", :dependent => :destroy

  # Search engine (ultrasphinx) indexes.
  ##is_indexed :fields => ['text', 'created_at'],
  ##           :include => [{:association_name => 'user', :field => 'screen_name'},
  ##           {:association_name => 'surfspot', :field => 'name'}]

  VALID_RATING = [0, 1, 2, 3, 4, 5]
  VALID_SURF_CONDITIONS = ["", "Poor", "Poor-Fair", "Fair", "Fair-Good", "Good", "Epic"]
  VALID_WAVE_HEIGHT = ["", "Flat", "Knee", "Waist", "Chest", "Head", "Over-Head"]
  VALID_CROWD_FACTOR = ["", "None", "Moderate", "Packed"]
  
  validates_presence_of :user_id, :rating, :text
  validates_length_of :text, :maximum => Surftrottr::Application.config.db_text_max_length

  def delete
	transaction do
	  SurfSessionEvent.destroy_all(:surf_session_id => self.id)
	  CommentEvent.destroy_all(:surf_session_id => self.id)
	  Comment.destroy_all(:commentable_type => Comment::SURF_SESSION, :commentable_id => self.id)
	  self.destroy
	end
  end

end

