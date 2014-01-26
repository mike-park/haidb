class ChangeCostDefault < ActiveRecord::Migration
  def up
    change_column_default(:registrations, :cost, nil)
    change_column_default(:registrations, :owed, nil)
    change_column_default(:registrations, :paid, nil)
    Registration.where(cost: 0).update_all(cost: nil)
    Registration.where(paid: 0).update_all(paid: nil)
    Registration.where(owed: 0).update_all(owed: nil)
  end

  def down
    Registration.where(cost: nil).update_all(cost: 0)
    Registration.where(paid: nil).update_all(paid: 0)
    Registration.where(owed: nil).update_all(owed: 0)
    change_column_default(:registrations, :cost, 0)
    change_column_default(:registrations, :owed, 0)
    change_column_default(:registrations, :paid, 0)
  end
end
