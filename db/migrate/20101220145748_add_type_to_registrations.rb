class AddTypeToRegistrations < ActiveRecord::Migration
  def self.up
    add_column :registrations, :type, :string
  end

  def self.down
    remove_column :registrations, :type
  end
end
