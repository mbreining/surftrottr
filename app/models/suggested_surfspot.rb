# == Schema Information
#
# Table name: suggested_surfspots
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  name       :string(255)
#  city       :string(255)
#  state      :string(255)
#  tag        :string(255)
#  comments   :text
#  processed  :boolean(1)      default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class SuggestedSurfspot < ActiveRecord::Base
  belongs_to :user

  STRING_FIELDS = %w(name city state comments)

  validates_presence_of :name, :city, :state
  validates_length_of STRING_FIELDS, :maximum => Surftrottr::Application.config.db_string_max_length

  # Return the full name of a location.
  def full_name
    [name, city, state].join(", ")
  end

  # Archive a suggested surfspot, i.e. mark it as processed.
  def archive!
    self.processed = true
    self.save
  end

end

