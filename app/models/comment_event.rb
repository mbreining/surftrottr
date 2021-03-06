# == Schema Information
#
# Table name: events
#
#  id                    :integer(4)      not null, primary key
#  user_id               :integer(4)      not null
#  surfspot_id           :integer(4)
#  report_id             :integer(4)
#  thirdparty_account_id :integer(4)
#  type                  :string(255)
#  action                :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#  surf_session_id       :integer(4)
#  friend_id             :integer(4)
#  comment_id            :integer(4)
#  gear_id               :integer(4)
#  surfboard_id          :integer(4)
#  post_id               :integer(4)
#

class CommentEvent < Event
  COMMENT_ADDED = 0

  validates_presence_of :comment_id, :action
end

