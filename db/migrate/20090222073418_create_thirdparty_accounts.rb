class CreateThirdpartyAccounts < ActiveRecord::Migration
  def self.up
    create_table :thirdparty_accounts do |t|
	  t.column :user_id, :integer, :null => false
	  t.column :active, :boolean, :default => true
      t.column :thirdparty_name, :string
	  t.column :src_user_id, :integer
	  t.column :src_screen_name, :string
	  t.column :src_avatar_url, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :thirdparty_accounts
  end
end
