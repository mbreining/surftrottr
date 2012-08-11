# == Schema Information
#
# Table name: votes
#
#  id         :integer(4)      not null, primary key
#  report_id  :integer(4)      not null
#  user_id    :integer(4)      not null
#  value      :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  
  validates_presence_of :report_id, :user_id
end

