class AddLatitudeToSurfspot < ActiveRecord::Migration
  def self.up
    add_column :surfspots, :latitude, :float
  end

  def self.down
    remove_column :surfspots, :latitude
  end
end
