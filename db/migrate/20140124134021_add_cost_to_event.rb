class AddCostToEvent < ActiveRecord::Migration
  def change
    add_column :events, :participant_cost, :decimal, :precision => 10, :scale => 2, :default => 0.0
    add_column :events, :team_cost, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end
end
