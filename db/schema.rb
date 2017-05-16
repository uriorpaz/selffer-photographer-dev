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

ActiveRecord::Schema.define(version: 20161108082120) do

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
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "error_logs", force: :cascade do |t|
    t.integer  "upload_log_id"
    t.text     "message"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "event_translations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "event_type"
    t.string   "lang"
    t.integer  "event_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "place"
    t.text     "pre_text"
    t.text     "long_description"
  end

  add_index "event_translations", ["event_id"], name: "index_event_translations_on_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "photographer_id"
    t.string   "name"
    t.datetime "date"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "photos_count",           default: 0
    t.integer  "guests",                 default: 0
    t.string   "slug"
    t.integer  "status",                 default: 0
    t.text     "share_message"
    t.integer  "watermark_portrait_id"
    t.integer  "watermark_landscape_id"
    t.boolean  "is_published",           default: false
    t.string   "event_type"
    t.string   "place"
    t.text     "pre_text"
    t.text     "description"
    t.text     "long_description"
    t.boolean  "needs_moderation",       default: false
  end

  add_index "events", ["photographer_id"], name: "index_events_on_photographer_id", using: :btree
  add_index "events", ["slug"], name: "index_events_on_slug", unique: true, using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "guest_invites", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "email"
    t.string   "phone"
    t.string   "code"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "status",     default: 0
  end

  add_index "guest_invites", ["event_id"], name: "index_guest_invites_on_event_id", using: :btree

  create_table "invites", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "invited_email"
    t.integer  "invited_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "code"
    t.string   "invite_subject"
    t.text     "invite_message"
  end

  add_index "invites", ["event_id"], name: "index_invites_on_event_id", using: :btree
  add_index "invites", ["invited_id"], name: "index_invites_on_invited_id", using: :btree

  create_table "links", force: :cascade do |t|
    t.integer  "share_id"
    t.string   "share_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "event_id"
  end

  create_table "photographers", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.string   "studio_name"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "country"
    t.string   "mobile_number"
    t.string   "office_number"
    t.string   "website"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "instagram"
    t.string   "logo"
    t.string   "slug"
    t.boolean  "is_owner",               default: false
  end

  add_index "photographers", ["email"], name: "index_photographers_on_email", unique: true, using: :btree
  add_index "photographers", ["reset_password_token"], name: "index_photographers_on_reset_password_token", unique: true, using: :btree
  add_index "photographers", ["slug"], name: "index_photographers_on_slug", unique: true, using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "img"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "comment"
    t.boolean  "like",                        default: false
    t.boolean  "album",                       default: false
    t.string   "original_filename"
    t.integer  "time_stamp",        limit: 8
    t.boolean  "background",                  default: false
    t.boolean  "priv",                        default: false
    t.boolean  "is_processed",                default: false
    t.string   "image_size"
    t.boolean  "from_api",                    default: false
    t.boolean  "is_show",                     default: true
    t.datetime "processed_at"
  end

  add_index "photos", ["event_id"], name: "index_photos_on_event_id", using: :btree
  add_index "photos", ["time_stamp", "event_id", "original_filename"], name: "index_photos_on_time_stamp_and_event_id_and_original_filename", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "upload_logs", force: :cascade do |t|
    t.integer  "event_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "photos_start_count"
    t.integer  "error_logs_count"
    t.integer  "duplicates_count"
    t.integer  "photos_end_count"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "not_photo_count"
    t.integer  "fail_count",         default: 0
  end

  add_index "upload_logs", ["event_id"], name: "index_upload_logs_on_event_id", using: :btree

  create_table "watermarks", force: :cascade do |t|
    t.integer  "photographer_id"
    t.boolean  "is_portrait",     default: true
    t.boolean  "is_default"
    t.string   "image_filename"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "watermarks", ["photographer_id"], name: "index_watermarks_on_photographer_id", using: :btree

  add_foreign_key "event_translations", "events"
  add_foreign_key "events", "photographers"
  add_foreign_key "guest_invites", "events"
  add_foreign_key "invites", "events"
  add_foreign_key "photos", "events"
  add_foreign_key "upload_logs", "events"
  add_foreign_key "watermarks", "photographers"
end
