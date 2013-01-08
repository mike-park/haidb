class AddCostToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :cost, :decimal, precision: 10, scale: 2, default: 0
    add_column :registrations, :paid, :decimal, precision: 10, scale: 2, default: 0
    add_column :registrations, :owed, :decimal, precision: 10, scale: 2, default: 0
  end
end
