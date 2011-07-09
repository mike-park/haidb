class DeviseCreateStaffs < ActiveRecord::Migration
  def self.up
    create_table(:staffs) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :staffs, :email,                :unique => true
    add_index :staffs, :reset_password_token, :unique => true
    # add_index :staffs, :confirmation_token,   :unique => true
    # add_index :staffs, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :staffs
  end
end
