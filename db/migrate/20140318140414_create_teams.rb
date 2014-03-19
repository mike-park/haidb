class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :event
      t.string :name, null: false
      t.date :date, null: false
      t.text :options
      t.boolean :closed, default: false
      t.integer :desired_size

      t.timestamps
    end
    add_index :teams, :event_id
  end
end
