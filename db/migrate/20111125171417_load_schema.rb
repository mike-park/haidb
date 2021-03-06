class LoadSchema < ActiveRecord::Migration
  def change
    create_table "admins", :force => true do |t|
      t.string "email", :default => "", :null => false
      t.string "encrypted_password", :limit => 128, :default => "", :null => false
      t.string "password_salt", :default => "", :null => false
      t.string "reset_password_token"
      t.string "remember_token"
      t.timestamp "remember_created_at"
      t.integer "sign_in_count", :default => 0
      t.timestamp "current_sign_in_at"
      t.timestamp "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.string "confirmation_token"
      t.timestamp "confirmed_at"
      t.timestamp "confirmation_sent_at"
      t.integer "failed_attempts", :default => 0
      t.string "unlock_token"
      t.timestamp "locked_at"
      t.string "authentication_token"
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    create_table "angels", :force => true do |t|
      t.string "display_name", :null => false
      t.string "first_name"
      t.string "last_name", :null => false
      t.string "gender", :null => false
      t.string "address"
      t.string "postal_code"
      t.string "city"
      t.string "country"
      t.string "email", :null => false
      t.string "home_phone"
      t.string "mobile_phone"
      t.string "work_phone"
      t.string "lang"
      t.text "notes"
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.integer "highest_level", :default => 0
      t.float "lat"
      t.float "lng"
    end

    add_index "angels", ["id"], :name => "index_angels_on_id"

    create_table "audits", :force => true do |t|
      t.integer "auditable_id"
      t.string "auditable_type"
      t.integer "association_id"
      t.string "association_type"
      t.integer "user_id"
      t.string "user_type"
      t.string "username"
      t.string "action"
      t.text "audited_changes"
      t.integer "version", :default => 0
      t.string "comment"
      t.string "remote_address"
      t.timestamp "created_at"
    end

    add_index "audits", ["association_id", "association_type"], :name => "association_index"
    add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
    add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
    add_index "audits", ["user_id", "user_type"], :name => "user_index"

    create_table "email_names", :force => true do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "emails", :force => true do |t|
      t.integer "email_name_id"
      t.string "locale"
      t.string "subject"
      t.text "body"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "emails", ["email_name_id"], :name => "index_emails_on_email_name_id"

    create_table "event_emails", :force => true do |t|
      t.integer "email_name_id"
      t.integer "event_id"
      t.string "category"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "event_emails", ["email_name_id"], :name => "index_event_emails_on_email_name_id"
    add_index "event_emails", ["event_id"], :name => "index_event_emails_on_event_id"

    create_table "events", :force => true do |t|
      t.string "display_name", :null => false
      t.string "category", :null => false
      t.integer "level", :default => 0
      t.date "start_date", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "events", ["id"], :name => "index_events_on_id"
    add_index "events", ["start_date"], :name => "index_events_on_start_date"

    create_table "histories", :force => true do |t|
      t.string "message"
      t.string "username"
      t.integer "item"
      t.string "table"
      t.integer "month"
      t.integer "year"
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    add_index "histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

    create_table "offices", :force => true do |t|
      t.string "email", :default => "", :null => false
      t.string "encrypted_password", :limit => 128, :default => "", :null => false
      t.string "password_salt", :default => "", :null => false
      t.string "reset_password_token"
      t.string "remember_token"
      t.timestamp "remember_created_at"
      t.integer "sign_in_count", :default => 0
      t.timestamp "current_sign_in_at"
      t.timestamp "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.string "confirmation_token"
      t.timestamp "confirmed_at"
      t.timestamp "confirmation_sent_at"
      t.integer "failed_attempts", :default => 0
      t.string "unlock_token"
      t.timestamp "locked_at"
      t.string "authentication_token"
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    create_table "public_signups", :force => true do |t|
      t.string "ip_addr"
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.timestamp "approved_at"
      t.string "status", :default => "pending"
    end

    create_table "registrations", :force => true do |t|
      t.integer "angel_id", :null => false
      t.integer "event_id", :null => false
      t.string "role", :default => "Participant", :null => false
      t.boolean "special_diet", :default => false
      t.boolean "backjack_rental", :default => false
      t.boolean "sunday_stayover", :default => false
      t.boolean "sunday_meal", :default => false
      t.string "sunday_choice"
      t.string "lift"
      t.string "payment_method", :default => "Direct"
      t.string "bank_account_nr"
      t.string "bank_account_name"
      t.string "bank_name"
      t.string "bank_sort_code"
      t.text "notes"
      t.boolean "completed", :default => false
      t.boolean "checked_in", :default => false
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.integer "public_signup_id"
      t.boolean "approved", :default => false
      t.string "how_hear"
      t.string "previous_event"
      t.boolean "reg_fee_received"
      t.boolean "clothing_conversation"
    end

    add_index "registrations", ["angel_id"], :name => "index_registrations_on_angel_id"
    add_index "registrations", ["event_id", "role"], :name => "index_registrations_on_role"
    add_index "registrations", ["event_id"], :name => "index_registrations_on_event_id"
    add_index "registrations", ["id"], :name => "index_registrations_on_id"

    create_table "site_defaults", :force => true do |t|
      t.integer "translation_key_id"
      t.text "description"
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    create_table "staffs", :force => true do |t|
      t.string "email", :default => "", :null => false
      t.string "encrypted_password", :limit => 128, :default => "", :null => false
      t.string "password_salt", :default => "", :null => false
      t.string "reset_password_token"
      t.string "remember_token"
      t.timestamp "remember_created_at"
      t.integer "sign_in_count", :default => 0
      t.timestamp "current_sign_in_at"
      t.timestamp "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.timestamp "created_at"
      t.timestamp "updated_at"
      t.boolean "super_user", :default => false
    end

    add_index "staffs", ["email"], :name => "index_staffs_on_email", :unique => true
    add_index "staffs", ["reset_password_token"], :name => "index_staffs_on_reset_password_token", :unique => true

    create_table "translation_keys", :force => true do |t|
      t.string "key", :null => false
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    add_index "translation_keys", ["key"], :name => "index_translation_keys_on_key"

    create_table "translation_texts", :force => true do |t|
      t.text "text"
      t.string "locale"
      t.integer "translation_key_id", :null => false
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    add_index "translation_texts", ["translation_key_id"], :name => "index_translation_texts_on_translation_key_id"

    create_table "users", :force => true do |t|
      t.string "email", :default => "", :null => false
      t.string "encrypted_password", :limit => 128, :default => "", :null => false
      t.string "password_salt", :default => "", :null => false
      t.string "reset_password_token"
      t.string "remember_token"
      t.timestamp "remember_created_at"
      t.integer "sign_in_count", :default => 0
      t.timestamp "current_sign_in_at"
      t.timestamp "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.string "confirmation_token"
      t.timestamp "confirmed_at"
      t.timestamp "confirmation_sent_at"
      t.integer "failed_attempts", :default => 0
      t.string "unlock_token"
      t.timestamp "locked_at"
      t.string "authentication_token"
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    add_index "users", ["email"], :name => "index_users_on_email", :unique => true
    add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  end
end
