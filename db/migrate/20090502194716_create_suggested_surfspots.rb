class CreateSuggestedSurfspots < ActiveRecord::Migration
  def self.up
    create_table :suggested_surfspots do |t|
	  t.column :user_id, :integer, :null => false
	  t.column :name, :string
	  t.column :city, :string
	  t.column :state, :string
	  t.column :tag, :string
	  t.column :comments, :text
	  t.column :processed, :boolean, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :suggested_surfspots
  end
end
