class AddEmbedLinkToSurfSession < ActiveRecord::Migration
  def self.up
    add_column :surf_sessions, :embed_link, :text, :default => nil
  end

  def self.down
    remove_column :surf_sessions, :embed_link
  end
end
