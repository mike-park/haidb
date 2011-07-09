class RemovePublicSignup < ActiveRecord::Migration
  def self.up
    drop_table :public_signups
    remove_column :angels, :status
    remove_column :registrations, :lang
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
