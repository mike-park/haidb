class Translations < ActiveRecord::Migration
  def self.up
    create_table "translation_keys", :force => true do |t|
      t.string   "key",        :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "translation_keys", ["key"], :name => "index_translation_keys_on_key"

    create_table "translation_texts", :force => true do |t|
      t.text     "text"
      t.string   "locale"
      t.integer  "translation_key_id", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "translation_texts", ["translation_key_id"], :name => "index_translation_texts_on_translation_key_id"
  end

  def self.down
    drop_table :translation_keys
    drop_table :translation_texts
  end
end
