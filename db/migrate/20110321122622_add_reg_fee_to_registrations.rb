class AddRegFeeToRegistrations < ActiveRecord::Migration
  def self.up
    add_column :registrations, :reg_fee_received, :boolean
    add_column :registrations, :clothing_conversation, :boolean
  end

  def self.down
    remove_column :registrations, :clothing_conversation
    remove_column :registrations, :reg_fee_received
  end
end
