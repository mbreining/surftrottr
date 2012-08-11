# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)
#  body             :text
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  ##is_indexed :fields => ['body']

  REPORT = "Report"
  SURF_SESSION = "SurfSession"
  GEAR = "Gear"
  SURFBOARD = "Surfboard"
  POST = "Post"

  validates_presence_of :body, :user, :commentable
  validates_length_of :body, :maximum => Surftrottr::Application.config.db_text_max_length
  # Prevent uniqueness of comments
  validates_uniqueness_of :body, :scope => [:user_id, :commentable_id, :commentable_type]

  # Return true for a duplicate comment (same user and body).
  #def duplicate?
    #c = Comment.find_by_
  #end

  # Check authorization for destroying comments.
  def authorized?(user)
    commentable.user == user
  end

end

