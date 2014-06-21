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

ActiveRecord::Schema.define(version: 20140610183145) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "agents", force: true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "display_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.integer  "account_type"
    t.integer  "availability"
    t.integer  "curr_chats"
    t.integer  "max_chats"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agents", ["email"], name: "index_agents_on_email", unique: true, using: :btree
  add_index "agents", ["organization_id"], name: "index_agents_on_organization_id", using: :btree
  add_index "agents", ["reset_password_token"], name: "index_agents_on_reset_password_token", unique: true, using: :btree

  create_table "chat_widgets", force: true do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.string   "online_message"
    t.string   "offline_message"
    t.string   "colour"
    t.boolean  "display_logo"
    t.boolean  "display_agent_avatar"
    t.boolean  "display_mobile_icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chats", force: true do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.integer  "visitor_id"
    t.integer  "agent_id"
    t.string   "agent_typing"
    t.string   "visitor_typing"
    t.datetime "chat_requested"
    t.datetime "chat_accepted"
    t.datetime "chat_ended"
    t.string   "visitor_name"
    t.string   "visitor_email"
    t.string   "visitor_department"
    t.string   "visitor_question"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chats", ["organization_id"], name: "index_chats_on_organization_id", using: :btree
  add_index "chats", ["website_id"], name: "index_chats_on_website_id", using: :btree

  create_table "departments", force: true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "email"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["organization_id"], name: "index_departments_on_organization_id", using: :btree

  create_table "offline_forms", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offline_messages", force: true do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.integer  "visitor_id"
    t.string   "name"
    t.string   "email"
    t.string   "department"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "max_agents"
    t.integer  "payment_system"
    t.integer  "inactive_visitor_removal"
    t.integer  "agent_session_timeout"
    t.integer  "agent_response_timeout"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prechat_forms", force: true do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.boolean  "enabled"
    t.string   "intro_text"
    t.string   "name_text"
    t.string   "email_text"
    t.boolean  "email_enabled"
    t.string   "department_text"
    t.boolean  "department_enabled"
    t.string   "message_text"
    t.string   "button_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rapid_responses", force: true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.string   "text"
    t.integer  "order"
    t.string   "ancestry"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rapid_responses", ["ancestry"], name: "index_rapid_responses_on_ancestry", using: :btree
  add_index "rapid_responses", ["organization_id"], name: "index_rapid_responses_on_organization_id", using: :btree

  create_table "visitors", force: true do |t|
    t.integer  "organization_id"
    t.integer  "website_id"
    t.string   "name"
    t.string   "email"
    t.string   "department"
    t.string   "question"
    t.datetime "last_ping"
    t.integer  "page_views"
    t.string   "current_page"
    t.string   "remote_addr"
    t.string   "remote_host"
    t.string   "country"
    t.string   "language"
    t.string   "referrer_host"
    t.string   "referrer_path"
    t.string   "referrer_search"
    t.string   "referrer_query"
    t.string   "search_engine"
    t.string   "search_query"
    t.string   "browser_name"
    t.string   "browser_version"
    t.string   "operating_system"
    t.string   "screen_resolution"
    t.string   "smart_invite_status"
    t.string   "operator_invite"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visitors", ["organization_id"], name: "index_visitors_on_organization_id", using: :btree
  add_index "visitors", ["website_id"], name: "index_visitors_on_website_id", using: :btree

  create_table "websites", force: true do |t|
    t.integer  "organization_id"
    t.string   "url",                default: "", null: false
    t.string   "name",               default: "", null: false
    t.integer  "default_department"
    t.string   "logo"
    t.boolean  "widget_installed"
    t.boolean  "smart_invites"
    t.string   "smart_invite_mode"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "websites", ["organization_id"], name: "index_websites_on_organization_id", using: :btree

end
