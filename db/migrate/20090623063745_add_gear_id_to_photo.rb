class AddGearIdToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :gear_id, :integer
  end

  def self.down
    remove_column :photos, :gear_id
  end
end
