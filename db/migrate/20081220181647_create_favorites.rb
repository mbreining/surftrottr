class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites do |t|
      t.integer :user_id, :null => false
      t.integer :surfspot_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :favorites
  end
end
