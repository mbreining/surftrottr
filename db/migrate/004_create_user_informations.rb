class CreateUserInformations < ActiveRecord::Migration
  def self.up
    create_table :user_informations do |t|
      t.column :user_id, :integer, :null => false
      t.column :first_name, :string, :default => ""
      t.column :last_name, :string, :default => ""
      t.column :city, :string, :default => ""
      t.column :state, :string, :default => ""
      t.column :zipcode, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :user_informations
  end
end
