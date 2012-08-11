class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
	  t.column :active, :boolean, :default => true
      t.column :screen_name, :string
      t.column :email, :string
      t.column :password, :string
	  t.column :authorization_token, :string
	  t.column :reason_for_deactivation, :string, :default => ""
      t.timestamps
    end
    
    User.create(:screen_name => "martin", :email => "feelnoway@gmail.com", :password => "passw0rd")
  end

  def self.down
    drop_table :users
  end
end
