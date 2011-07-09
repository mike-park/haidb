class CreateSiteDefaults < ActiveRecord::Migration
  def self.up
    create_table :site_defaults do |t|
      t.references :translation_key
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :site_defaults
  end
end
