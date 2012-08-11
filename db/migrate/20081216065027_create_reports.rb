class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
	  # So far, can be either StandardReport or TwitterReport.
	  t.string :type
	  
	  # Required attributes.
      t.integer :surfspot_id, :null => false
      t.integer :user_id, :null => false
	  
	  # Common attributes.
      t.text :text
      t.timestamp :actual_created_at

	  # Standard report attributes.
      t.string :surf_conditions
      t.boolean :advanced_only
      t.string :wave_height
      t.string :wind_direction
      t.string :wind_speed
      t.string :paddle_out
      t.string :crowd_factor
	  	  
	  # Thirdparty report attributes.
	  t.integer :thirdparty_account_id
	  t.integer :src_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
