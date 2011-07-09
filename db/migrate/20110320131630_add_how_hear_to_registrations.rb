class AddHowHearToRegistrations < ActiveRecord::Migration
  def self.up
    add_column :registrations, :how_hear, :string
    add_column :registrations, :previous_event, :string
  end

  def self.down
    remove_column :registrations, :previous_event
    remove_column :registrations, :how_hear
  end
end
