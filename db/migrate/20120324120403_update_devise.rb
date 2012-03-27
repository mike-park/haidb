class UpdateDevise < ActiveRecord::Migration
  def change
    add_column :staffs, :reset_password_sent_at, :datetime
    change_column :staffs, :encrypted_password, :string, null: false, default: ""
  end
end
