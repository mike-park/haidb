class CreatePublicSignups < ActiveRecord::Migration
  def self.up
    create_table :public_signups do |t|
      t.references :registration, :null => false
      t.references :angel, :null => false
      t.references :event, :null => false
      t.string :lang, :default => 'en'

      t.timestamps
    end
  end

  def self.down
    drop_table :public_signups
  end
end
