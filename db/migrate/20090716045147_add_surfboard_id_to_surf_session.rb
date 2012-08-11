class AddSurfboardIdToSurfSession < ActiveRecord::Migration
  def self.up
    add_column :surf_sessions, :surfboard_id, :integer
  end

  def self.down
    remove_column :surf_sessions, :surfboard_id
  end
end
