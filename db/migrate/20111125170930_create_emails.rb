class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.references :email_name
      t.string :locale
      t.string :subject
      t.text :body

      t.timestamps
    end
    add_index :emails, :email_name_id
  end
end
