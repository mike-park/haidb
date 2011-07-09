class Baseline < ActiveRecord::Migration
  def self.up

  create_table "angels", :force => true do |t|
    t.string   "display_name",                     :null => false
    t.string   "first_name"
    t.string   "last_name",                      :null => false
    t.string   "gender",                         :null => false
    t.string   "address"
    t.string   "postal_code"
    t.string   "city"
    t.string   "country"
    t.string   "email",                          :null => false
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "work_phone"
    t.string   "lang",         :default => "en"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "angels", ["id"], :name => "index_angels_on_id"

  create_table "events", :force => true do |t|
    t.string   "display_name",                :null => false
    t.string   "category",                  :null => false
    t.integer  "level",      :default => 0
    t.date     "start_date",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["id"], :name => "index_events_on_id"
  add_index "events", ["start_date"], :name => "index_events_on_start_date"

  create_table "registrations", :force => true do |t|
    t.integer  "angel_id",                             :null => false
    t.integer  "event_id",                             :null => false
    t.string   "display_name",                           :null => false
    t.string   "first_name"
    t.string   "last_name",                            :null => false
    t.string   "gender",                               :null => false
    t.string   "role",                                 :null => false
    t.boolean  "special_diet",      :default => false
    t.boolean  "backjack_rental",   :default => false
    t.boolean  "sunday_stayover",   :default => false
    t.boolean  "sunday_meal",       :default => false
    t.string   "sunday_choice"
    t.string   "lift"
    t.string   "payment_method"
    t.string   "bank_account_nr"
    t.string   "bank_account_name"
    t.string   "bank_name"
    t.string   "bank_sort_code"
    t.string   "lang",              :default => "en"
    t.text     "notes"
    t.boolean  "completed",         :default => false
      t.boolean  "checked_in",        :default => false
      t.string  "status", :default => 'new'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registrations", ["angel_id"], :name => "index_registrations_on_angel_id"
  add_index "registrations", ["event_id", "gender"], :name => "index_registrations_on_gender"
  add_index "registrations", ["event_id", "role"], :name => "index_registrations_on_role"
  add_index "registrations", ["event_id"], :name => "index_registrations_on_event_id"
  add_index "registrations", ["id"], :name => "index_registrations_on_id"
  add_index "registrations", ["status"], :name => "index_registrations_on_status"

  end
  

  def self.down
    [:angels, :events, :registrations].each do |t|
      drop_table t
    end
  end
end
