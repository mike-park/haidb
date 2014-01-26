class RemoveEventDefaultCosts < ActiveRecord::Migration
  def up
    change_column_default(:events, :participant_cost, nil)
    change_column_default(:events, :team_cost, nil)
    Event.where(participant_cost: 0).update_all(participant_cost: nil)
    Event.where(team_cost: 0).update_all(team_cost: nil)
  end

  def down
    Event.where(participant_cost: nil).update_all(participant_cost: 0)
    Event.where(team_cost: nil).update_all(team_cost: 0)
    change_column_default(:events, :participant_cost, 0)
    change_column_default(:events, :team_cost, 0)
  end
end
