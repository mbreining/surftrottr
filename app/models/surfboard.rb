# == Schema Information
#
# Table name: surfboards
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      not null
#  category    :string(255)     not null
#  length      :string(255)     not null
#  brand       :string(255)     not null
#  description :text
#  link        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Surfboard < ActiveRecord::Base
  belongs_to :user
  has_many :surf_session
  has_many :photos
  accepts_nested_attributes_for :photos, :allow_destroy => true
  has_many :comments, :as => :commentable, :order => "created_at", :dependent => :destroy

  ##is_indexed :fields => ['length', 'brand', 'description', 'category', 'created_at'],
  ##           :include => [{:association_name => 'user', :field => 'screen_name'}]

  SHORTBOARD = 'Shortboard'
  FISH = 'Fish'
  GUN = 'Gun'
  LONGBOARD = 'Longboard'
  MALIBU = 'Malibu'
  FUNBOARD = 'Funboard'
  OTHER = 'Other'
  
  VALID_SURFBOARD_TYPES = [SHORTBOARD, FISH, GUN, LONGBOARD, MALIBU, FUNBOARD, OTHER]

  VALID_LENGTHS = ['5\'0"', '5\'1"', '5\'2"', '5\'3"', '5\'4"', '5\'5"', '5\'6"', '5\'7"', '5\'8"',
                   '5\'9"', '5\'10"', '5\'11"', '6\'0"', '6\'1"', '6\'2"', '6\'3"', '6\'4"', '6\'5"', 
				   '6\'6"', '6\'7"', '6\'8"', '6\'9"', '6\'10"', '6\'11"', '7\'0"', '7\'1"', '7\'2"',
				   '7\'3"', '7\'4"', '7\'5"', '7\'6"', '7\'7"', '7\'8"', '7\'9"', '7\'10"', '7\'11"', 
				   '8\'0"', '8\'1"', '8\'2"', '8\'3"', '8\'4"', '8\'5"', '8\'6"', '8\'7"', '8\'8"', 
				   '8\'9"', '8\'10"', '8\'11"', '9\'0"', '9\'1"', '9\'2"', '9\'3"', '9\'4"', '9\'5"',
				   '9\'6"', '9\'7"', '9\'8"', '9\'9"', '9\'10"', '9\'11"', '10\'0"', '10\'1"', '10\'2"',
				   '10\'3"', '10\'4"', '10\'5"', '10\'6"', '10\'7"', '10\'8"', '10\'9"', '10\'10"', '10\'11"',
				   '11\'0"', '11\'1"', '11\'2"', '11\'3"', '11\'4"', '11\'5"', '11\'6"', '11\'7"', '11\'8"',
				   '11\'9"', '11\'10"', '11\'11"', '12\'0"', '12\'1"', '12\'2"', '12\'3"', '12\'4"', '12\'4"',
				   '12\'5"', '12\'6"', '12\'7"', '12\'8"', '12\'9"', '12\'10"', '12\'11"', '13\'0"',
				   '13\'1"', '13\'2"', '13\'3"', '13\'4"', '13\'5"', '13\'6"', '13\'7"', '13\'8"', '13\'9"',
				   '13\'10"', '13\'11"', '14\'0"']

  validates_presence_of :user_id, :length, :brand
  validates_length_of :description, :maximum => Surftrottr::Application.config.db_text_max_length

  def name
    [length, brand].join(" ")
  end
  
  def delete
	transaction do
	  SurfboardEvent.destroy_all(:surfboard_id => self.id)
	  CommentEvent.destroy_all(:surfboard_id => self.id)
	  Comment.destroy_all(:commentable_type => Comment::SURFBOARD, :commentable_id => self.id)
	  self.destroy
	end
  end
end

