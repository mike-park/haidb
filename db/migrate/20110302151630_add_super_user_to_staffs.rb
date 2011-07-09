class AddSuperUserToStaffs < ActiveRecord::Migration
  def self.up
    add_column :staffs, :super_user, :boolean, :default => false
  end

  def self.down
    remove_column :staffs, :super_user
  end
end
