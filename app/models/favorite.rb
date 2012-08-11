# == Schema Information
#
# Table name: favorites
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)      not null
#  surfspot_id :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :surfspot
  
  validates_presence_of :user_id, :surfspot_id
  
  # Return true if the favorite surfspot already exists.
  def self.exists?(user, surfspot)
    not find_by_user_id_and_surfspot_id(user, surfspot).nil?
  end
  
  # Add a favorite surfspot for a given user.
  def self.add(user, surfspot)
    unless Favorite.exists?(user, surfspot)
	  create(:user => user, :surfspot => surfspot)
	end
  end
  
  # Remove a favorite surfspot for a given user.
  def self.remove(user, surfspot)
    destroy(find_by_user_id_and_surfspot_id(user, surfspot))
  end
end

