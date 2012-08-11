# == Schema Information
#
# Table name: thirdparty_accounts
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)      not null
#  active          :boolean(1)      default(TRUE)
#  thirdparty_name :string(255)
#  src_user_id     :integer(4)
#  src_screen_name :string(255)
#  src_avatar_url  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class ThirdpartyAccount < ActiveRecord::Base
  belongs_to :user

  TWITTER = "Twitter"
  VALID_THIRDPARTIES = [TWITTER]

  # Note that when a user removes a thirdparty account, we do not delete the 
  # thirdparty account record in the database. Instead we keep the record
  # in the database but mark it as inactive (:active => false).
  validates_presence_of :user_id, :thirdparty_name, :src_screen_name
  validates_inclusion_of :thirdparty_name,
                         :in => VALID_THIRDPARTIES,
                         :allow_nil => false
			
  def is_active?
    self.active
  end
  
  def activate!
    self.update_attribute(:active, true)
  end
  
  def disactivate!
    self.update_attribute(:active, false)
  end
end

