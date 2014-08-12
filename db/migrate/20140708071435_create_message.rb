class CreateMessage < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :source, polymorphic: true
      t.references :staff
      t.string :subject, null: false
      t.text :message, null: false
      t.text :to_list, null: false
      t.text :cc_list
      t.text :bcc_list
      t.string :from, null: false
      t.text :header
      t.text :footer
      t.timestamps
    end
  end
end
