class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
	  t.integer :report_id, :null => false
      t.integer :user_id, :null => false
	  t.integer :value
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
