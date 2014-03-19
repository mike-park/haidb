class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :angel, null: false
      t.references :team, null: false
      t.references :membership, null: false
      t.string :full_name, null: false
      t.string :gender, null: false
      t.text :notes
      t.string :role
      t.date :approved_on

      t.timestamps
    end
    add_index :members, :angel_id
    add_index :members, :team_id
    add_index :members, :membership_id
  end
end
