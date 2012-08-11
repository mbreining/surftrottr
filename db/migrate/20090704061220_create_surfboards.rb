class CreateSurfboards < ActiveRecord::Migration
  def self.up
    create_table :surfboards do |t|
	  t.integer :user_id, :null => false
	  t.string :category, :null => false
	  t.string :length, :null => false
	  t.string :brand, :null => false
	  t.text :description
	  t.string :link
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :surfboards
  end
end
