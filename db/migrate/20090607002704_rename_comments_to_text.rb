class RenameCommentsToText < ActiveRecord::Migration
  def self.up
    rename_column :surf_sessions, :comments, :text
  end

  def self.down
    rename_column :surf_sessions, :text, :comments
  end
end
