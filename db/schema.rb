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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150516051705) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "agents", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "name",                   default: "", null: false
    t.string   "display_name",           default: "", null: false
    t.string   "title",                  default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.integer  "access_level"
    t.integer  "availability"
    t.boolean  "active_chat_sound"
    t.boolean  "background_chat_sound"
    t.boolean  "visitor_arrived_sound"
    t.string   "avatar"
    t.integer  "status"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "agents", ["email"], name: "index_agents_on_email", unique: true, using: :btree
  add_index "agents", ["organization_id"], name: "index_agents_on_organization_id", using: :btree
  add_index "agents", ["reset_password_token"], name: "index_agents_on_reset_password_token", unique: true, using: :btree

  create_table "agents_departments", id: false, force: :cascade do |t|
    t.integer "agent_id",      null: false
    t.integer "department_id", null: false
  end

  add_index "agents_departments", ["agent_id", "department_id"], name: "index_agents_departments_on_agent_id_and_department_id", using: :btree

  create_table "agents_websites", id: false, force: :cascade do |t|
    t.integer "agent_id",   null: false
    t.integer "website_id", null: false
  end

  add_index "agents_websites", ["agent_id", "website_id"], name: "index_agents_websites_on_agent_id_and_website_id", using: :btree

  create_table "chat_messages", force: :cascade do |t|
    t.integer  "chat_id"
    t.string   "user_name"
    t.integer  "sender"
    t.datetime "sent"
    t.boolean  "seen_by_agent",   default: false
    t.boolean  "seen_by_visitor", default: false
    t.text     "message"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "chat_widgets", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.string   "online_message"
    t.string   "offline_message"
    t.string   "title_message"
    t.boolean  "hide_when_offline"
    t.string   "color"
    t.string   "logo"
    t.boolean  "display_logo"
    t.boolean  "display_agent_avatar"
    t.boolean  "display_mobile_icon"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "chats", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.integer  "visitor_id"
    t.integer  "agent_id",           default: 0
    t.string   "agent_typing",       default: ""
    t.string   "visitor_typing",     default: ""
    t.datetime "chat_requested"
    t.datetime "chat_accepted"
    t.datetime "chat_ended"
    t.string   "visitor_name",       default: ""
    t.string   "visitor_email",      default: ""
    t.string   "visitor_department", default: ""
    t.string   "visitor_question",   default: ""
    t.integer  "status"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "chats", ["organization_id"], name: "index_chats_on_organization_id", using: :btree
  add_index "chats", ["website_id"], name: "index_chats_on_website_id", using: :btree

  create_table "departments", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "email"
    t.integer  "website_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "departments", ["organization_id"], name: "index_departments_on_organization_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.string   "invitation_message"
    t.string   "name_text"
    t.string   "button_text"
    t.integer  "invite_mode"
    t.integer  "invite_pageviews"
    t.integer  "invite_seconds"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "offline_forms", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.string   "intro_text"
    t.string   "name_text"
    t.string   "email_text"
    t.boolean  "email_enabled"
    t.string   "department_text"
    t.boolean  "department_enabled"
    t.string   "message_text"
    t.string   "button_text"
    t.text     "success_message"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "offline_messages", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.integer  "visitor_id"
    t.string   "name"
    t.string   "email"
    t.string   "department"
    t.text     "message"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.integer  "account_type",           default: 0,  null: false
    t.integer  "payment_system",         default: 0
    t.integer  "agent_session_timeout",  default: 30
    t.integer  "agent_response_timeout", default: 2
    t.boolean  "completed_setup"
    t.integer  "status"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "trial_days",             default: 14, null: false
    t.datetime "trial_period_end"
    t.string   "stripe_customer_id",     default: ""
    t.datetime "expiration_date"
    t.datetime "date_reminded"
  end

  create_table "prechat_forms", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.string   "intro_text"
    t.string   "name_text"
    t.string   "email_text"
    t.boolean  "email_enabled"
    t.string   "department_text"
    t.boolean  "department_enabled"
    t.string   "message_text"
    t.string   "button_text"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "rapid_responses", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "website_id",      default: 0
    t.string   "name"
    t.string   "text"
    t.integer  "order"
    t.string   "ancestry"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "rapid_responses", ["ancestry"], name: "index_rapid_responses_on_ancestry", using: :btree
  add_index "rapid_responses", ["organization_id"], name: "index_rapid_responses_on_organization_id", using: :btree
  add_index "rapid_responses", ["website_id"], name: "index_rapid_responses_on_website_id", using: :btree

  create_table "stripe_webhooks", force: :cascade do |t|
    t.string   "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "stripe_id"
    t.integer  "quantity"
    t.datetime "active_until"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "subscriptions", ["organization_id"], name: "index_subscriptions_on_organization_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "visitor_archives", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "website_id",          default: 0
    t.integer  "chat_id",             default: 0
    t.string   "name",                default: ""
    t.string   "email",               default: ""
    t.string   "department",          default: ""
    t.string   "question",            default: ""
    t.datetime "last_ping"
    t.integer  "page_views",          default: 0
    t.string   "current_page",        default: ""
    t.string   "language",            default: ""
    t.string   "referrer_host",       default: ""
    t.string   "referrer_path",       default: ""
    t.string   "referrer_search",     default: ""
    t.string   "referrer_query",      default: ""
    t.string   "search_engine",       default: ""
    t.string   "search_query",        default: ""
    t.string   "browser_name",        default: ""
    t.string   "browser_version",     default: ""
    t.string   "operating_system",    default: ""
    t.string   "screen_resolution",   default: ""
    t.string   "smart_invite_status", default: ""
    t.string   "operator_invite",     default: ""
    t.string   "ip_address",          default: ""
    t.string   "latitude",            default: ""
    t.string   "longitude",           default: ""
    t.string   "country_code",        default: ""
    t.string   "country_name",        default: ""
    t.string   "city",                default: ""
    t.string   "region_code",         default: ""
    t.string   "region_name",         default: ""
    t.string   "area_code",           default: ""
    t.string   "metro_code",          default: ""
    t.string   "zipcode",             default: ""
    t.integer  "status"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "visitor_archives", ["organization_id"], name: "index_visitor_archives_on_organization_id", using: :btree

  create_table "visitors", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "website_id",          default: 0
    t.integer  "chat_id",             default: 0
    t.string   "name",                default: ""
    t.string   "email",               default: ""
    t.string   "department",          default: ""
    t.string   "question",            default: ""
    t.string   "smart_invite_status", default: ""
    t.integer  "agent_invite_status", default: 0
    t.integer  "invite_agent_id",     default: 0
    t.datetime "last_ping"
    t.integer  "page_views",          default: 0
    t.string   "current_page",        default: ""
    t.string   "language",            default: ""
    t.string   "referrer_host",       default: ""
    t.string   "referrer_path",       default: ""
    t.string   "referrer_search",     default: ""
    t.string   "referrer_query",      default: ""
    t.string   "search_engine",       default: ""
    t.string   "search_query",        default: ""
    t.string   "browser_name",        default: ""
    t.string   "browser_version",     default: ""
    t.string   "operating_system",    default: ""
    t.string   "screen_resolution",   default: ""
    t.string   "operator_invite",     default: ""
    t.string   "ip_address",          default: ""
    t.string   "latitude",            default: ""
    t.string   "longitude",           default: ""
    t.string   "country_code",        default: ""
    t.string   "country_name",        default: ""
    t.string   "city",                default: ""
    t.string   "region_code",         default: ""
    t.string   "region_name",         default: ""
    t.string   "area_code",           default: ""
    t.string   "metro_code",          default: ""
    t.string   "zipcode",             default: ""
    t.integer  "status"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "browser_fingerprint"
  end

  add_index "visitors", ["browser_fingerprint"], name: "index_visitors_on_browser_fingerprint", using: :btree
  add_index "visitors", ["organization_id"], name: "index_visitors_on_organization_id", using: :btree
  add_index "visitors", ["website_id"], name: "index_visitors_on_website_id", using: :btree

  create_table "websites", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "url",               default: "", null: false
    t.string   "name",              default: "", null: false
    t.string   "email",             default: "", null: false
    t.datetime "last_ping"
    t.boolean  "smart_invites"
    t.string   "smart_invite_mode"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "websites", ["organization_id"], name: "index_websites_on_organization_id", using: :btree

  add_foreign_key "subscriptions", "organizations"
end
