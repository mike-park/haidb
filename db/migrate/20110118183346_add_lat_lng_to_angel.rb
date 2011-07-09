class AddLatLngToAngel < ActiveRecord::Migration
  def self.up
    add_column :angels, :lat, :float
    add_column :angels, :lng, :float
  end

  def self.down
    drop_columns :angels, :lat, :lng
  end
end
