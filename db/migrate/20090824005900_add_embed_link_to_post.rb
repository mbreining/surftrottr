class AddEmbedLinkToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :embed_link, :text, :default => nil
  end

  def self.down
    remove_column :posts, :embed_link
  end
end
