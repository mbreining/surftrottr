class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
	  t.column :user_id, :integer, :null => false
	  t.column :surfspot_id, :integer
	  t.column :report_id, :integer
	  t.column :thirdparty_account_id, :integer
	  t.column :type, :string
	  t.column :action, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
