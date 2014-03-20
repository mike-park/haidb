class AddStatusToMembers < ActiveRecord::Migration
  def change
    add_column(:members, :status, :text)

    add_index :members, :gender
    add_index :registrations, :gender
    add_index :registrations, :approved
  end
end
