# == Schema Information
#
# Table name: posts
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  title      :string(255)
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#  embed_link :text
#

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  accepts_nested_attributes_for :photos, :allow_destroy => true
  has_many :comments, :as => :commentable, :order => "created_at", :dependent => :destroy

  ##is_indexed :fields => ['title', 'text', 'created_at'],
  ##           :include => [{:association_name => 'user', :field => 'screen_name'}]

  validates_presence_of :user_id, :title, :text
  validates_length_of :text, :maximum => Surftrottr::Application.config.db_text_max_length

  def delete
	transaction do
	  PostEvent.destroy_all(:post_id => self.id)
	  CommentEvent.destroy_all(:post_id => self.id)
	  Comment.destroy_all(:commentable_type => Comment::POST, :commentable_id => self.id)
	  self.destroy
	end
  end
end

