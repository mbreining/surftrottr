class CreateSurfSessions < ActiveRecord::Migration
  def self.up
    create_table :surf_sessions do |t|
      t.integer :user_id, :null => false
      t.integer :surfspot_id
      t.integer :rating, :null => false
      t.string :surfboard
      t.string :surf_conditions
      t.string :wave_height
      t.string :crowd_factor
	  t.text :comments
      t.timestamp :actual_date

      t.timestamps
    end
  end

  def self.down
    drop_table :surf_sessions
  end
end
