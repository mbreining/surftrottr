# == Schema Information
#
# Table name: reports
#
#  id                    :integer(4)      not null, primary key
#  type                  :string(255)
#  surfspot_id           :integer(4)      not null
#  user_id               :integer(4)      not null
#  text                  :text
#  actual_created_at     :datetime
#  surf_conditions       :string(255)
#  advanced_only         :boolean(1)
#  wave_height           :string(255)
#  wind_direction        :string(255)
#  wind_speed            :string(255)
#  paddle_out            :string(255)
#  crowd_factor          :string(255)
#  thirdparty_account_id :integer(4)
#  src_id                :integer(8)
#  created_at            :datetime
#  updated_at            :datetime
#  source                :string(255)     default("web")
#  score                 :integer(4)      default(0)
#

# Describes reports generated from the Twitter platform.
class TwitterReport < Report
  validates_presence_of :text, :thirdparty_account_id, :src_id
end
