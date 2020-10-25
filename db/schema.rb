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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_06_04_045523) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "agents", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.string "name", default: "", null: false
    t.string "display_name", default: "", null: false
    t.string "title", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "access_level"
    t.integer "availability", default: 0
    t.boolean "active_chat_sound", default: true
    t.boolean "background_chat_sound", default: true
    t.boolean "visitor_arrived_sound", default: true
    t.string "avatar"
    t.integer "status", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_seen_at"
    t.string "time_zone", default: "UTC"
    t.index ["confirmation_token"], name: "index_agents_on_confirmation_token", unique: true
    t.index ["email"], name: "index_agents_on_email", unique: true
    t.index ["organization_id"], name: "index_agents_on_organization_id"
    t.index ["reset_password_token"], name: "index_agents_on_reset_password_token", unique: true
  end

  create_table "agents_departments", id: false, force: :cascade do |t|
    t.integer "agent_id", null: false
    t.integer "department_id", null: false
    t.index ["agent_id", "department_id"], name: "index_agents_departments_on_agent_id_and_department_id"
  end

  create_table "agents_websites", id: false, force: :cascade do |t|
    t.integer "agent_id", null: false
    t.integer "website_id", null: false
    t.index ["agent_id", "website_id"], name: "index_agents_websites_on_agent_id_and_website_id"
  end

  create_table "chat_messages", id: :serial, force: :cascade do |t|
    t.integer "chat_id"
    t.string "user_name"
    t.integer "sender"
    t.datetime "sent"
    t.boolean "seen_by_agent", default: false
    t.boolean "seen_by_visitor", default: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_widgets", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "website_id"
    t.string "online_message"
    t.string "offline_message"
    t.string "title_message"
    t.boolean "hide_when_offline"
    t.string "color"
    t.string "logo"
    t.boolean "display_logo"
    t.boolean "display_agent_avatar"
    t.boolean "display_mobile_icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "website_id"
    t.integer "visitor_id"
    t.integer "agent_id", default: 0
    t.string "agent_typing", default: ""
    t.string "visitor_typing", default: ""
    t.datetime "chat_requested"
    t.datetime "chat_accepted"
    t.datetime "chat_ended"
    t.string "visitor_name", default: ""
    t.string "visitor_email", default: ""
    t.string "visitor_department", default: ""
    t.string "visitor_question", default: ""
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_chats_on_organization_id"
    t.index ["website_id"], name: "index_chats_on_website_id"
  end

  create_table "departments", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.string "name"
    t.string "email"
    t.integer "website_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_departments_on_organization_id"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "website_id"
    t.string "invitation_message"
    t.string "name_text"
    t.string "button_text"
    t.integer "invite_mode"
    t.integer "invite_pageviews"
    t.integer "invite_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_payments", id: :serial, force: :cascade do |t|
    t.string "stripe_id", null: false
    t.integer "amount", default: 0, null: false
    t.integer "fee_amount"
    t.integer "quantity", default: 1, null: false
    t.string "interval"
    t.string "currency"
    t.boolean "discount"
    t.string "coupon"
    t.integer "organization_id"
    t.integer "subscription_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_invoice_payments_on_organization_id"
    t.index ["subscription_id"], name: "index_invoice_payments_on_subscription_id"
  end

  create_table "offline_forms", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "website_id"
    t.string "intro_text"
    t.string "name_text"
    t.string "email_text"
    t.boolean "email_enabled"
    t.string "department_text"
    t.boolean "department_enabled"
    t.string "message_text"
    t.string "button_text"
    t.text "success_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offline_messages", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "website_id"
    t.integer "visitor_id"
    t.string "name"
    t.string "email"
    t.string "department"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organization_ftp_servers", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.string "host_address"
    t.string "username"
    t.string "password"
    t.string "directory"
    t.text "comments"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_ftp_servers_on_organization_id"
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.integer "account_type", default: 0, null: false
    t.integer "payment_system", default: 0
    t.integer "agent_session_timeout", default: 30
    t.integer "agent_response_timeout", default: 2
    t.boolean "completed_setup", default: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trial_days", default: 14, null: false
    t.datetime "trial_period_end"
    t.string "stripe_customer_id"
    t.datetime "expiration_date"
    t.datetime "date_reminded"
    t.integer "setup_step", default: 0
  end

  create_table "prechat_forms", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "website_id"
    t.string "intro_text"
    t.string "name_text"
    t.string "email_text"
    t.boolean "email_enabled"
    t.string "department_text"
    t.boolean "department_enabled"
    t.string "message_text"
    t.string "button_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rapid_responses", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "website_id", default: 0
    t.string "name"
    t.string "text"
    t.integer "order"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_rapid_responses_on_ancestry"
    t.index ["organization_id"], name: "index_rapid_responses_on_organization_id"
    t.index ["website_id"], name: "index_rapid_responses_on_website_id"
  end

  create_table "stripe_webhooks", id: :serial, force: :cascade do |t|
    t.string "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.string "stripe_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "active_until"
    t.string "plan_id"
    t.string "interval"
    t.integer "amount"
    t.string "coupon"
    t.datetime "current_period_end"
    t.datetime "current_period_start"
    t.datetime "billing_start"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_subscriptions_on_organization_id"
  end

  create_table "version_associations", id: :serial, force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.integer "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  create_table "visitor_archives", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "website_id", default: 0
    t.integer "chat_id", default: 0
    t.string "name", default: ""
    t.string "email", default: ""
    t.string "department", default: ""
    t.string "question", default: ""
    t.datetime "last_ping"
    t.integer "page_views", default: 0
    t.string "current_page", default: ""
    t.string "language", default: ""
    t.string "referrer_host", default: ""
    t.string "referrer_path", default: ""
    t.string "referrer_search", default: ""
    t.string "referrer_query", default: ""
    t.string "search_engine", default: ""
    t.string "search_query", default: ""
    t.string "browser_name", default: ""
    t.string "browser_version", default: ""
    t.string "operating_system", default: ""
    t.string "screen_resolution", default: ""
    t.string "smart_invite_status", default: ""
    t.string "operator_invite", default: ""
    t.string "ip_address", default: ""
    t.string "latitude", default: ""
    t.string "longitude", default: ""
    t.string "country_code", default: ""
    t.string "country_name", default: ""
    t.string "city", default: ""
    t.string "region_code", default: ""
    t.string "region_name", default: ""
    t.string "area_code", default: ""
    t.string "metro_code", default: ""
    t.string "zipcode", default: ""
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_visitor_archives_on_organization_id"
  end

  create_table "visitors", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "website_id", default: 0
    t.integer "chat_id", default: 0
    t.string "name", default: ""
    t.string "email", default: ""
    t.string "department", default: ""
    t.string "question", default: ""
    t.integer "smart_invite_status", default: 0
    t.integer "agent_invite_status", default: 0
    t.integer "invite_agent_id", default: 0
    t.datetime "last_ping"
    t.integer "page_views", default: 0
    t.string "current_page", default: ""
    t.string "language", default: ""
    t.string "referrer_host", default: ""
    t.string "referrer_path", default: ""
    t.string "referrer_search", default: ""
    t.string "referrer_query", default: ""
    t.string "search_engine", default: ""
    t.string "search_query", default: ""
    t.string "browser_name", default: ""
    t.string "browser_version", default: ""
    t.string "operating_system", default: ""
    t.string "screen_resolution", default: ""
    t.string "operator_invite", default: ""
    t.string "ip_address", default: ""
    t.string "latitude", default: ""
    t.string "longitude", default: ""
    t.string "country_code", default: ""
    t.string "country_name", default: ""
    t.string "city", default: ""
    t.string "region_code", default: ""
    t.string "region_name", default: ""
    t.string "area_code", default: ""
    t.string "metro_code", default: ""
    t.string "zipcode", default: ""
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "browser_fingerprint"
    t.index ["browser_fingerprint"], name: "index_visitors_on_browser_fingerprint"
    t.index ["organization_id"], name: "index_visitors_on_organization_id"
    t.index ["website_id"], name: "index_visitors_on_website_id"
  end

  create_table "websites", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.string "url", default: "", null: false
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.datetime "last_ping"
    t.boolean "smart_invites"
    t.string "smart_invite_mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_websites_on_organization_id"
  end

  add_foreign_key "invoice_payments", "organizations"
  add_foreign_key "organization_ftp_servers", "organizations"
  add_foreign_key "subscriptions", "organizations"
end
