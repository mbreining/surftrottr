class CreateSurfspots < ActiveRecord::Migration
  def self.up
    create_table :surfspots do |t|
	  t.column :name, :string
	  t.column :city, :string
	  t.column :state, :string
	  t.column :zipcode, :integer
	  t.column :tag, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :surfspots
  end
end
