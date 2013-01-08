class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :registration
      t.date :paid_on
      t.string :note
      t.decimal :amount, :precision => 10, :scale => 2, default: 0.0

      t.timestamps
    end
    add_index :payments, :registration_id
  end
end
