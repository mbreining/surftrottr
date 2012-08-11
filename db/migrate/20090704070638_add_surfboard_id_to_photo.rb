class AddSurfboardIdToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :surfboard_id, :integer
  end

  def self.down
    remove_column :photos, :surfboard_id
  end
end
