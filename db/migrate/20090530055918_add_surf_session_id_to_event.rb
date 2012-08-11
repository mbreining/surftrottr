class AddSurfSessionIdToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :surf_session_id, :integer
  end

  def self.down
    remove_column :events, :surf_session_id
  end
end
