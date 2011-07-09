class RemoveRedundentFields < ActiveRecord::Migration
  def self.up
    remove_columns :registrations, :display_name, :first_name, :last_name, :gender, :type
    add_column :angels, :highest_level, :integer, :default => 0
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
