class ChangeSrcIdInReports < ActiveRecord::Migration
  def self.up
    change_column :reports, :src_id, :bigint
  end

  def self.down
    change_column :reports, :src_id, :int
  end
end
