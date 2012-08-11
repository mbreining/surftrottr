class AddPostIdToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :post_id, :integer
  end

  def self.down
    remove_column :photos, :post_id
  end
end
