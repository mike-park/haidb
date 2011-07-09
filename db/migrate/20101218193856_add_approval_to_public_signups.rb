class AddApprovalToPublicSignups < ActiveRecord::Migration
  def self.up
    add_column :public_signups, :status, :string, :default => PublicSignup::PENDING
    add_column :angels, :status, :string, :default => Angel::PENDING
    add_index :public_signups, :status
    add_index :angels, :status
    change_column :registrations, :status, :string, :default => Registration::PENDING
    remove_column :public_signups, :angel_id
    remove_column :public_signups, :event_id

    Angel.reset_column_information
    Angel.update_all(:status => Angel::VALID)
    Registration.reset_column_information
    Registration.update_all(:status => Registration::APPROVED)
    PublicSignup.all.each do |p|
      p.registration.status = Registration::PENDING
      p.save!
    end
  end

  def self.down
    remove_index  :public_signups, :status
    remove_index  :angels, :status
    remove_column :public_signups, :status
    remove_column :angels, :status
    change_column :registrations, :status, :string, :default => 'new'
    add_column :public_signups, :angel_id, :integer
    add_column :public_signups, :event_id, :integer
  end
end
