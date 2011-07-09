class Publicsignup2 < ActiveRecord::Migration
  def self.up
    add_column :registrations, :public_signup_id, :integer
    add_column :registrations, :approved, :boolean
    remove_column :registrations, :status
    create_table(:public_signups) do |t|
      t.string :ip_addr
      t.timestamps
    end      
  end

  def self.down
    drop_table :public_signups
    remove_column :registrations, :public_signup_id
    remove_column :registrations, :approved
    add_column :registrations, :status, :string
  end
end
