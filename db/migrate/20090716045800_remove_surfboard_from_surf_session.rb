class RemoveSurfboardFromSurfSession < ActiveRecord::Migration
  def self.up
    remove_column :surf_sessions, :surfboard
  end

  def self.down
    add_column :surf_sessions, :surfboard, :string
  end
end
