class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
	  t.column :report_id, :integer
	  t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
