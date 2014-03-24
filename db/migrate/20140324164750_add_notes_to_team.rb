class AddNotesToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :notes, :text
  end
end
