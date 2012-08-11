class AddGearIdToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :gear_id, :integer
  end

  def self.down
    remove_column :events, :gear_id
  end
end
