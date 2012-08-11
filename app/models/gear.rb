# == Schema Information
#
# Table name: gears
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      not null
#  category    :string(255)     not null
#  name        :string(255)     not null
#  brand       :string(255)
#  description :text
#  link        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Gear < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  accepts_nested_attributes_for :photos, :allow_destroy => true
  has_many :comments, :as => :commentable, :order => "created_at", :dependent => :destroy

  ##is_indexed :fields => ['name', 'description', 'category', 'brand', 'created_at'],
  ##           :include => [{:association_name => 'user', :field => 'screen_name'}]

  WETSUIT = 'Wetsuit'
  BOOTIES = 'Booties'
  HOOD = 'Hood'
  RASHGUARD = 'Rashguard'
  LEASH = 'Leash'
  TRACTION_PAD = 'TractionPad'
  FIN = 'Fin'
  BOARD_BAG = 'BoardBag'
  SUN_PROTECTION = 'SunProtection'
  ELECTRONIC = 'Electronic'
  OTHER = 'Other'
  
  VALID_GEAR_TYPES = [WETSUIT, BOOTIES, HOOD, RASHGUARD, LEASH, TRACTION_PAD, FIN, BOARD_BAG, SUN_PROTECTION, ELECTRONIC, OTHER]

  validates_presence_of :user_id, :name, :description
  validates_length_of :description, :maximum => Surftrottr::Application.config.db_text_max_length

  def delete
    transaction do
	  GearEvent.destroy_all(:gear_id => self.id)
	  CommentEvent.destroy_all(:gear_id => self.id)
	  Comment.destroy_all(:commentable_type => Comment::GEAR, :commentable_id => self.id)
	  self.destroy
	end
  end
  
end

