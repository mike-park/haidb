class CreateEmailNames < ActiveRecord::Migration
  def change
    create_table :email_names do |t|
      t.string :name

      t.timestamps
    end
  end
end
