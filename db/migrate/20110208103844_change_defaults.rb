class ChangeDefaults < ActiveRecord::Migration
  def self.up
    change_column :angels, :lang, :string, :default => nil
    change_column :registrations, :role, :string, :default => 'Participant'
    change_column :registrations, :payment_method, :string, :default => 'Direct'
    change_column :registrations, :approved, :boolean, :default => false
  end

  def self.down
    change_column :angels, :lang, :string, :default => 'en'
    change_column :registrations, :role, :string, :default => nil
    change_column :registrations, :approved, :boolean, :default => nil
    change_column :registrations, :payment_method, :string, :default => nil
  end
end
