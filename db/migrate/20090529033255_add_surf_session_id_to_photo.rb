class AddSurfSessionIdToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :surf_session_id, :integer
  end

  def self.down
    remove_column :photos, :surf_session_id
  end
end
