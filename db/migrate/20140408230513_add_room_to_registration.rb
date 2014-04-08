class AddRoomToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :room, :string
  end
end
