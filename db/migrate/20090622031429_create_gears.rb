class CreateGears < ActiveRecord::Migration
  def self.up
    create_table :gears do |t|
	  t.integer :user_id, :null => false
	  t.string :category, :null => false
	  t.string :name, :null => false
	  t.string :brand
	  t.text :description, :null => false
	  t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :gears
  end
end
