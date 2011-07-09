class AddApprovedAt < ActiveRecord::Migration
  def self.up
    add_column :public_signups, :approved_at, :datetime
  end

  def self.down
    remove_column :public_signups, :approved_at
  end
end
