class AddStatusToPublicSignup < ActiveRecord::Migration
  def self.up
    add_column :public_signups, :status, :string, :default => 'pending'
    PublicSignup.reset_column_information
    PublicSignup.update_all(:status => 'pending')
    PublicSignup.where('approved_at is not NULL').all.each do |p|
      p.update_attribute(:status, 'approved')
    end
  end

  def self.down
    remove_column :public_signups, :status
  end
end
