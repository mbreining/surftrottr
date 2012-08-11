class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :name, :string
      t.timestamps
    end
    
    # Add an index to the name field of the Roles table.
    # Create an 'Admin' role.
    add_index :roles, :name
    Role.create(:name => "Admin")
  end

  def self.down
    drop_table :roles
  end
end
