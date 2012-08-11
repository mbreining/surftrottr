# == Schema Information
#
# Table name: user_informations
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  first_name :string(255)     default("")
#  last_name  :string(255)     default("")
#  city       :string(255)     default("")
#  state      :string(255)     default("")
#  zipcode    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class UserInformation < ActiveRecord::Base
  belongs_to :user

  #is_indexed :fields => ['first_name', 'last_name']

  ALL_FIELDS = %w(first_name last_name city state zipcode reports_posted)
  STRING_FIELDS = %w(first_name last_name city state)
  ZIPCODE_LENGTH = 5

  # Doesn't seem to work with nested objects in rails 2.3.
  validates_presence_of :first_name, :city, :state
  validates_length_of STRING_FIELDS, :maximum => Surftrottr::Application.config.db_string_max_length
  validates_format_of :zipcode, :with => /(^$|^[0-9]{#{ZIPCODE_LENGTH}}$)/,
                      :message => "must be a five digit number"

  # Return the full name (first plus last).
  def full_name
    last_name.length == 0 ? first_name : [first_name, last_name].join(" ")
  end

  # Return a sensibly formatted location string.
  def location
    [city, state].join(", ")
  end

  # Perform a text search on a user information.
  # Uses Sphinx under the covers.
  def self.text_search(q)
    search = Ultrasphinx::Search.new(:query => q, :class_names => 'UserInformation')
    search.run
    search.results
  end
end

