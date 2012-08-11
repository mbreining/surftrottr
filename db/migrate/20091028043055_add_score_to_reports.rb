class AddScoreToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :score, :integer, :default => 0
  end

  def self.down
    remove_column :reports, :score
  end
end
