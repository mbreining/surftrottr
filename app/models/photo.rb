# == Schema Information
#
# Table name: photos
#
#  id                 :integer(4)      not null, primary key
#  report_id          :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(4)
#  image_updated_at   :datetime
#  surf_session_id    :integer(4)
#  gear_id            :integer(4)
#  surfboard_id       :integer(4)
#  post_id            :integer(4)
#

class Photo < ActiveRecord::Base
  # Images sizes.
  # We use ImageMagick to convert images.
  MINI_SIZE = "40x40#"
  THUMB_SIZE = "100x100#"
  NORMAL_SIZE = "600x440>"

  belongs_to :report
  belongs_to :surf_session
  belongs_to :gear
  belongs_to :post
  has_attached_file :image, 
                    :styles => {:mini => MINI_SIZE, :thumb => THUMB_SIZE, :normal => NORMAL_SIZE },
  					:default_size => :normal

  validates_attachment_size :image, :in => 1..1.megabyte
end

