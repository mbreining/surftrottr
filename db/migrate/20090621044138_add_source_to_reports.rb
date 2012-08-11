class AddSourceToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :source, :string, :default => "Web"
  end

  def self.down
    remove_column :reports, :source
  end
end
