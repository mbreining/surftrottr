# == Schema Information
#
# Table name: surfspots
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  city       :string(255)
#  state      :string(255)
#  zipcode    :integer(4)
#  tag        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  latitude   :float
#  longitude  :float
#

class Surfspot < ActiveRecord::Base
  has_many :reports, :order => "actual_created_at DESC", :dependent => :destroy
  has_many :surf_sessions, :order => "created_at DESC", :dependent => :destroy
  has_many :favorites
  has_many :report_photos, :source => :photos, :through => :reports
  has_many :surf_session_photos, :source => :photos, :through => :surf_sessions

  ##is_indexed :fields => ['name', 'city', 'state', 'tag']

  ALL_FIELDS = %w(name city state zipcode)
  STRING_FIELDS = %w(name city state)
  ZIPCODE_LENGTH = 5

  validates_presence_of :name, :city, :state, :zipcode, :tag
  validates_length_of STRING_FIELDS, :maximum => Surftrottr::Application.config.db_string_max_length
  validates_format_of :zipcode, :with => /(^$|^[0-9]{#{ZIPCODE_LENGTH}}$)/,
                      :message => "must be a five digit number"

  # Return the full name of a location.
  def full_name
    [name, city, state].join(", ")
  end

  # Return all surfspot photos.
  def photos
    photos = self.report_photos + self.surf_session_photos
    photos.sort! { |a, b|  b.created_at <=> a.created_at }
  end

  # Find surfspots within a given range.
  def self.geo_search(surfspot, miles)
    distance = sql_distance_away(surfspot)
    where(["#{distance} <= ? AND name != ?", miles, surfspot.name])
    .order("state, city, name")
  end

  # Perform a text search on a surfspot.
  # Uses Sphinx under the covers.
  def self.text_search(q)
    search = Ultrasphinx::Search.new(:query => q, :class_names => 'Surfspot')
    search.run
    search.results
  end

  private

  # Return SQL (WHERE clause) for the distance between a surfspot's location and a given point.
  # This method is used to find all surfspots within a certain distance from a given surfspot/point.
  # See http://en.wikipedia.org/wiki/Haversine_formula for more on the formula.
  def self.sql_distance_away(point)
    h = "POWER(SIN((RADIANS(latitude - #{point.latitude}))/2.0),2) + " + \
    "COS(RADIANS(#{point.latitude})) * COS(RADIANS(latitude)) * " + \
    "POWER(SIN((RADIANS(longitude - #{point.longitude}))/2.0),2)"
    r = 3956 # Earth's radius in miles
    "2 * #{r} * ASIN(SQRT(#{h}))"
  end
end

