class AddLongitudeToSurfspot < ActiveRecord::Migration
  def self.up
    add_column :surfspots, :longitude, :float
  end

  def self.down
    remove_column :surfspots, :longitude
  end
end
