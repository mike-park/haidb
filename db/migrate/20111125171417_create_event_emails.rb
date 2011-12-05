class CreateEventEmails < ActiveRecord::Migration
  def change
    create_table :event_emails do |t|
      t.references :email_name
      t.references :event
      t.string :category

      t.timestamps
    end
    add_index :event_emails, :email_name_id
    add_index :event_emails, :event_id
  end
end
