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

# Describes report generated from the shredr.com platform.
class StandardReport < Report

  VALID_SURF_CONDITIONS = ["Poor", "Poor-Fair", "Fair", "Fair-Good", "Good", "Epic"]
  VALID_WAVE_HEIGHT = ["Flat", "Knee", "Waist", "Chest", "Head", "Over-Head"]
  VALID_WIND_DIRECTION = ["", "Calm", "N", "NE", "E", "SE", "S", "SW", "W", "NW", "Variable"]
  VALID_WIND_SPEED = ["", "Calm", "Light", "Moderate", "Strong", "Violent"]
  VALID_PADDLE_OUT = ["", "Easy", "Moderate", "Difficult"]
  VALID_CROWD_FACTOR = ["", "None", "Moderate", "Packed"]

  validates_presence_of :surf_conditions, :wave_height
  validates_inclusion_of :surf_conditions,
                         :in => VALID_SURF_CONDITIONS,
                         :allow_nil => false
  validates_inclusion_of :wave_height,
                         :in => VALID_WAVE_HEIGHT,
                         :allow_nil => false
  validates_inclusion_of :wind_direction,
                         :in => VALID_WIND_DIRECTION,
                         :allow_nil => true
  validates_inclusion_of :wind_speed,
                         :in => VALID_WIND_SPEED,
                         :allow_nil => true
  validates_inclusion_of :paddle_out,
                         :in => VALID_PADDLE_OUT,
                         :allow_nil => true
  validates_inclusion_of :crowd_factor,
                         :in => VALID_CROWD_FACTOR,
                         :allow_nil => true
end
