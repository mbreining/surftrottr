class CreateUserRoles < ActiveRecord::Migration
  def self.up
    create_table :user_roles do |t|
      t.column :user_id, :integer, :null => false
      t.column :role_id, :integer, :null => false
      t.timestamps
    end
    
    User.first.add_role "Admin"
  end

  def self.down
    drop_table :user_roles
  end
end
