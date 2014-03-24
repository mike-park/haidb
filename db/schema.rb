# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140324164750) do

  create_table "angels", :force => true do |t|
    t.string   "display_name",                     :null => false
    t.string   "first_name"
    t.string   "last_name",                        :null => false
    t.string   "gender"
    t.string   "address"
    t.string   "postal_code"
    t.string   "city"
    t.string   "country"
    t.string   "email",                            :null => false
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "work_phone"
    t.string   "lang"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "highest_level",     :default => 0
    t.float    "lat"
    t.float    "lng"
    t.text     "gravatar"
    t.string   "payment_method"
    t.string   "bank_account_name"
    t.string   "iban"
    t.string   "bic"
  end

  add_index "angels", ["id"], :name => "index_angels_on_id"

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "association_id"
    t.string   "association_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",          :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["association_id", "association_type"], :name => "association_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "email_names", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.integer  "email_name_id"
    t.string   "locale"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["email_name_id"], :name => "index_emails_on_email_name_id"

  create_table "event_emails", :force => true do |t|
    t.integer  "email_name_id"
    t.integer  "event_id"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_emails", ["email_name_id"], :name => "index_event_emails_on_email_name_id"
  add_index "event_emails", ["event_id"], :name => "index_event_emails_on_event_id"

  create_table "events", :force => true do |t|
    t.string   "display_name",                                                   :null => false
    t.string   "category",                                                       :null => false
    t.integer  "level",                                           :default => 0
    t.date     "start_date",                                                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "options"
    t.decimal  "participant_cost", :precision => 10, :scale => 2
    t.decimal  "team_cost",        :precision => 10, :scale => 2
  end

  add_index "events", ["id"], :name => "index_events_on_id"
  add_index "events", ["start_date"], :name => "index_events_on_start_date"

  create_table "histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "members", :force => true do |t|
    t.integer  "angel_id",      :null => false
    t.integer  "team_id",       :null => false
    t.integer  "membership_id", :null => false
    t.string   "full_name",     :null => false
    t.string   "gender",        :null => false
    t.text     "notes"
    t.string   "role"
    t.date     "approved_on"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "status"
  end

  add_index "members", ["angel_id"], :name => "index_members_on_angel_id"
  add_index "members", ["gender"], :name => "index_members_on_gender"
  add_index "members", ["membership_id"], :name => "index_members_on_membership_id"
  add_index "members", ["team_id"], :name => "index_members_on_team_id"

  create_table "memberships", :force => true do |t|
    t.integer  "angel_id"
    t.string   "status"
    t.date     "active_on"
    t.date     "retired_on"
    t.text     "notes"
    t.text     "options"
    t.decimal  "participant_cost", :precision => 10, :scale => 2
    t.decimal  "team_cost",        :precision => 10, :scale => 2
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "memberships", ["angel_id"], :name => "index_memberships_on_angel_id"
  add_index "memberships", ["status"], :name => "index_memberships_on_status"

  create_table "offices", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "registration_id"
    t.date     "paid_on"
    t.string   "note"
    t.decimal  "amount",          :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  add_index "payments", ["registration_id"], :name => "index_payments_on_registration_id"

  create_table "public_signups", :force => true do |t|
    t.string   "ip_addr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "approved_at"
    t.string   "status",      :default => "pending"
  end

  create_table "registrations", :force => true do |t|
    t.integer  "angel_id"
    t.integer  "event_id",                                                                        :null => false
    t.string   "role",                                                 :default => "Participant", :null => false
    t.boolean  "special_diet",                                         :default => false
    t.boolean  "backjack_rental",                                      :default => false
    t.boolean  "sunday_stayover",                                      :default => false
    t.boolean  "sunday_meal",                                          :default => false
    t.string   "sunday_choice"
    t.string   "lift"
    t.string   "payment_method"
    t.string   "iban"
    t.string   "bank_account_name"
    t.string   "bank_name"
    t.string   "bic"
    t.text     "notes"
    t.boolean  "completed",                                            :default => false
    t.boolean  "checked_in",                                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "public_signup_id"
    t.boolean  "approved",                                             :default => false
    t.string   "how_hear"
    t.string   "previous_event"
    t.boolean  "reg_fee_received"
    t.boolean  "clothing_conversation"
    t.text     "options"
    t.decimal  "cost",                  :precision => 10, :scale => 2
    t.decimal  "paid",                  :precision => 10, :scale => 2
    t.decimal  "owed",                  :precision => 10, :scale => 2
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "address"
    t.string   "postal_code"
    t.string   "city"
    t.string   "country"
    t.string   "email"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "work_phone"
    t.string   "lang"
    t.string   "highest_level"
    t.string   "highest_location"
    t.string   "highest_date"
    t.string   "registration_code"
    t.float    "lat"
    t.float    "lng"
  end

  add_index "registrations", ["angel_id"], :name => "index_registrations_on_angel_id"
  add_index "registrations", ["approved"], :name => "index_registrations_on_approved"
  add_index "registrations", ["event_id", "role"], :name => "index_registrations_on_role"
  add_index "registrations", ["event_id"], :name => "index_registrations_on_event_id"
  add_index "registrations", ["gender"], :name => "index_registrations_on_gender"
  add_index "registrations", ["id"], :name => "index_registrations_on_id"

  create_table "site_defaults", :force => true do |t|
    t.integer  "translation_key_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "staffs", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "password_salt",          :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super_user",             :default => false
    t.datetime "reset_password_sent_at"
  end

  add_index "staffs", ["email"], :name => "index_staffs_on_email", :unique => true
  add_index "staffs", ["reset_password_token"], :name => "index_staffs_on_reset_password_token", :unique => true

  create_table "teams", :force => true do |t|
    t.integer  "event_id"
    t.string   "name",                            :null => false
    t.date     "date",                            :null => false
    t.text     "options"
    t.boolean  "closed",       :default => false
    t.integer  "desired_size"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.text     "notes"
  end

  add_index "teams", ["event_id"], :name => "index_teams_on_event_id"

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

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "angel_id"
    t.text     "options"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
