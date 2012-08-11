class AddFriendIdToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :friend_id, :integer
  end

  def self.down
    remove_column :events, :friend_id
  end
end
