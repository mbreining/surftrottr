class AddSurfboardIdToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :surfboard_id, :integer
  end

  def self.down
    remove_column :events, :surfboard_id
  end
end
