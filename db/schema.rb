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

  create_table "archives", force: :cascade do |t|
    t.string   "file",       limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",      limit: 255
    t.integer  "event_id"
    t.string   "slug",       limit: 255
  end

  add_index "archives", ["event_id"], name: "index_archives_on_event_id", using: :btree
  add_index "archives", ["slug"], name: "index_archives_on_slug", using: :btree
  add_index "archives", ["user_id"], name: "index_archives_on_user_id", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",      limit: 255, null: false
    t.string   "proid",         limit: 255, null: false
    t.string   "token",         limit: 255
    t.string   "refresh_token", limit: 255
    t.string   "secret",        limit: 255
    t.datetime "expires_at"
    t.string   "username",      limit: 255
    t.string   "image_url",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider"], name: "index_authentications_on_provider", using: :btree
  add_index "authentications", ["user_id"], name: "fk__authentications_user_id", using: :btree

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
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "photos_count",                       default: 0
    t.integer  "guests",                             default: 0
    t.string   "slug"
    t.integer  "status",                             default: 0
    t.text     "share_message"
    t.integer  "watermark_portrait_id"
    t.integer  "watermark_landscape_id"
    t.boolean  "is_published",                       default: true
    t.string   "event_type"
    t.string   "place"
    t.text     "pre_text"
    t.text     "description"
    t.text     "long_description"
    t.boolean  "send_notification",                  default: false
    t.boolean  "requires_password",                  default: false
    t.string   "password",               limit: 255
    t.text     "terms_of_use"
    t.text     "facebook_share_text"
    t.boolean  "needs_moderation",                   default: false
  end

  add_index "events", ["photographer_id"], name: "index_events_on_photographer_id", using: :btree
  add_index "events", ["slug"], name: "index_events_on_slug", unique: true, using: :btree

  create_table "face_images", force: :cascade do |t|
    t.string   "image",        limit: 255, null: false
    t.datetime "time_taken"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_uid",      limit: 255
    t.string   "face_api_uid", limit: 255
    t.integer  "user_id",                  null: false
  end

  add_index "face_images", ["user_id"], name: "fk__face_images_user_id", using: :btree

  create_table "fb_albums", force: :cascade do |t|
    t.string   "user",        limit: 255
    t.integer  "event_id"
    t.string   "album_ident", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fb_albums", ["event_id"], name: "index_fb_albums_on_event_id", using: :btree

  create_table "friend_faces", force: :cascade do |t|
    t.string   "face_ident",          limit: 255
    t.string   "image",               limit: 255
    t.integer  "temp_recognition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cluster_ident"
  end

  add_index "friend_faces", ["temp_recognition_id"], name: "index_friend_faces_on_temp_recognition_id", using: :btree

  create_table "friend_faces_recognitions", force: :cascade do |t|
    t.integer "friend_face_id"
    t.integer "recognition_id"
  end

  add_index "friend_faces_recognitions", ["friend_face_id"], name: "index_friend_faces_recognitions_on_friend_face_id", using: :btree
  add_index "friend_faces_recognitions", ["recognition_id"], name: "index_friend_faces_recognitions_on_recognition_id", using: :btree

  create_table "friend_faces_temp_recognitions", force: :cascade do |t|
    t.integer "friend_face_id"
    t.integer "temp_recognition_id"
  end

  add_index "friend_faces_temp_recognitions", ["friend_face_id"], name: "index_friend_faces_temp_recognitions_on_friend_face_id", using: :btree
  add_index "friend_faces_temp_recognitions", ["temp_recognition_id"], name: "index_friend_faces_temp_recognitions_on_temp_recognition_id", using: :btree

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

  create_table "oauth_caches", id: false, force: :cascade do |t|
    t.integer  "authentication_id", null: false
    t.text     "data_json",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_caches", ["authentication_id"], name: "index_oauth_caches_on_authentication_id", using: :btree

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
    t.boolean  "always_show",                 default: false
  end

  add_index "photos", ["event_id"], name: "index_photos_on_event_id", using: :btree
  add_index "photos", ["time_stamp", "event_id", "original_filename"], name: "index_photos_on_time_stamp_and_event_id_and_original_filename", unique: true, using: :btree

  create_table "photos_shares", force: :cascade do |t|
    t.integer "photo_id"
    t.integer "share_id"
  end

  add_index "photos_shares", ["photo_id"], name: "index_photos_shares_on_photo_id", using: :btree
  add_index "photos_shares", ["share_id"], name: "index_photos_shares_on_share_id", using: :btree

  create_table "possible_faces", force: :cascade do |t|
    t.string   "face_ident",    limit: 255
    t.string   "image",         limit: 255
    t.integer  "similarity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cluster_ident"
  end

  create_table "possible_faces_recognitions", force: :cascade do |t|
    t.integer "possible_face_id"
    t.integer "recognition_id"
  end

  add_index "possible_faces_recognitions", ["possible_face_id"], name: "index_possible_faces_recognitions_on_possible_face_id", using: :btree
  add_index "possible_faces_recognitions", ["recognition_id"], name: "index_possible_faces_recognitions_on_recognition_id", using: :btree

  create_table "possible_faces_temp_recognitions", force: :cascade do |t|
    t.integer "possible_face_id"
    t.integer "temp_recognition_id"
  end

  add_index "possible_faces_temp_recognitions", ["possible_face_id"], name: "index_possible_faces_temp_recognitions_on_possible_face_id", using: :btree
  add_index "possible_faces_temp_recognitions", ["temp_recognition_id"], name: "index_possible_faces_temp_recognitions_on_temp_recognition_id", using: :btree

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message"
    t.string   "username",   limit: 255
    t.integer  "item"
    t.string   "table",      limit: 255
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "recognition_photos", force: :cascade do |t|
    t.integer  "photo_id"
    t.integer  "recognition_id"
    t.integer  "confidence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "share"
    t.integer  "face_width"
    t.integer  "face_x"
    t.integer  "face_y"
    t.string   "group_ident",    limit: 255
    t.boolean  "is_group_match"
  end

  add_index "recognition_photos", ["photo_id"], name: "fk__recognition_photos_photo_id", using: :btree
  add_index "recognition_photos", ["recognition_id", "photo_id"], name: "pr_r_photo", unique: true, using: :btree
  add_index "recognition_photos", ["recognition_id"], name: "fk__recognition_photos_recognition_id", using: :btree
  add_index "recognition_photos", ["recognition_id"], name: "pr_r", using: :btree

  create_table "recognitions", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                      null: false
    t.integer  "event_id",                                     null: false
    t.datetime "last_started"
    t.datetime "last_finished"
    t.integer  "current_progress"
    t.integer  "times_recognized"
    t.boolean  "in_progress"
    t.string   "fb_album",         limit: 255
    t.boolean  "loading",                      default: false
    t.string   "slug",             limit: 255
    t.integer  "subscriber_id"
    t.integer  "subs_face_ident"
  end

  add_index "recognitions", ["event_id"], name: "fk__recognitions_event_id", using: :btree
  add_index "recognitions", ["slug"], name: "index_recognitions_on_slug", using: :btree
  add_index "recognitions", ["subscriber_id"], name: "index_recognitions_on_subscriber_id", using: :btree
  add_index "recognitions", ["user_id"], name: "fk__recognitions_user_id", using: :btree

  create_table "shares", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",       limit: 255
  end

  create_table "shortened_urls", force: :cascade do |t|
    t.text     "url",                               null: false
    t.string   "unique_key", limit: 10,             null: false
    t.integer  "use_count",             default: 0, null: false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shortened_urls", ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true, using: :btree
  add_index "shortened_urls", ["url"], name: "index_shortened_urls_on_url", using: :btree

  create_table "subscribers", force: :cascade do |t|
    t.string   "email",         limit: 255
    t.string   "image_url",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "photos_amount",             default: 0
    t.integer  "face_ident"
  end

  add_index "subscribers", ["event_id"], name: "index_subscribers_on_event_id", using: :btree

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

  create_table "temp_face_images", force: :cascade do |t|
    t.integer  "temp_recognition_id"
    t.string   "image",               limit: 255, null: false
    t.string   "api_uid",             limit: 255
    t.string   "face_api_uid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "temp_face_images", ["temp_recognition_id"], name: "fk__temp_face_images_temp_recognition_id", using: :btree

  create_table "temp_face_images_temp_recognitions", force: :cascade do |t|
    t.integer  "temp_face_image_id"
    t.integer  "temp_recognition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "temp_face_images_temp_recognitions", ["temp_face_image_id"], name: "fk__temp_face_images_temp_recognitions_temp_face_image_id", using: :btree
  add_index "temp_face_images_temp_recognitions", ["temp_recognition_id", "temp_face_image_id"], name: "recog_fi", unique: true, using: :btree
  add_index "temp_face_images_temp_recognitions", ["temp_recognition_id"], name: "fi_tr_recog", using: :btree
  add_index "temp_face_images_temp_recognitions", ["temp_recognition_id"], name: "fk__temp_face_images_temp_recognitions_temp_recognition_id", using: :btree

  create_table "temp_recognition_photos", force: :cascade do |t|
    t.integer  "photo_id"
    t.integer  "temp_recognition_id"
    t.integer  "confidence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "share"
    t.integer  "face_width"
    t.integer  "face_x"
    t.integer  "face_y"
    t.string   "group_ident",         limit: 255
    t.boolean  "is_group_match"
  end

  add_index "temp_recognition_photos", ["photo_id"], name: "fk__temp_recognition_photos_photo_id", using: :btree
  add_index "temp_recognition_photos", ["temp_recognition_id", "photo_id"], name: "ptr_tr_photo", unique: true, using: :btree
  add_index "temp_recognition_photos", ["temp_recognition_id"], name: "fk__temp_recognition_photos_temp_recognition_id", using: :btree
  add_index "temp_recognition_photos", ["temp_recognition_id"], name: "ptr_tr", using: :btree

  create_table "temp_recognitions", force: :cascade do |t|
    t.integer  "event_id",                                     null: false
    t.string   "email",            limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_started"
    t.datetime "last_finished"
    t.integer  "current_progress"
    t.integer  "times_recognized"
    t.boolean  "in_progress"
    t.string   "uuid",             limit: 255
    t.string   "fb_album",         limit: 255
    t.boolean  "loading",                      default: false
    t.string   "slug",             limit: 255
    t.datetime "end_recog_at"
    t.datetime "start_recog_at"
    t.integer  "photos_count",                 default: 0
    t.integer  "subscriber_id"
    t.integer  "subs_face_ident"
  end

  add_index "temp_recognitions", ["event_id"], name: "fk__temp_recognitions_event_id", using: :btree
  add_index "temp_recognitions", ["slug"], name: "index_temp_recognitions_on_slug", using: :btree
  add_index "temp_recognitions", ["subscriber_id"], name: "index_temp_recognitions_on_subscriber_id", using: :btree

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

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "image_url",              limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["is_admin"], name: "index_users_on_is_admin", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "watermarks", force: :cascade do |t|
    t.integer  "photographer_id"
    t.boolean  "is_portrait",     default: true
    t.boolean  "is_default"
    t.string   "image_filename"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "watermarks", ["photographer_id"], name: "index_watermarks_on_photographer_id", using: :btree

  add_foreign_key "archives", "events"
  add_foreign_key "archives", "users", name: "fk_archives_user_id"
  add_foreign_key "event_translations", "events"
  add_foreign_key "events", "photographers"
  add_foreign_key "face_images", "users", name: "fk_face_images_user_id"
  add_foreign_key "friend_faces", "temp_recognitions", name: "fk_friend_faces_temp_recognition_id"
  add_foreign_key "friend_faces_recognitions", "friend_faces", name: "fk_friend_faces_recognitions_friend_face_id"
  add_foreign_key "friend_faces_recognitions", "recognitions", name: "fk_friend_faces_recognitions_recognition_id"
  add_foreign_key "friend_faces_temp_recognitions", "friend_faces", name: "fk_friend_faces_temp_recognitions_friend_face_id"
  add_foreign_key "friend_faces_temp_recognitions", "temp_recognitions", name: "fk_friend_faces_temp_recognitions_temp_recognition_id"
  add_foreign_key "guest_invites", "events"
  add_foreign_key "invites", "events"
  add_foreign_key "photos", "events"
  add_foreign_key "photos_shares", "shares", name: "fk_photos_shares_share_id"
  add_foreign_key "possible_faces_recognitions", "possible_faces", name: "fk_possible_faces_recognitions_possible_face_id"
  add_foreign_key "possible_faces_recognitions", "recognitions", name: "fk_possible_faces_recognitions_recognition_id"
  add_foreign_key "possible_faces_temp_recognitions", "possible_faces", name: "fk_possible_faces_temp_recognitions_possible_face_id"
  add_foreign_key "possible_faces_temp_recognitions", "temp_recognitions", name: "fk_possible_faces_temp_recognitions_temp_recognition_id"
  add_foreign_key "recognition_photos", "recognitions", name: "fk_recognition_photos_recognition_id"
  add_foreign_key "recognitions", "subscribers", name: "fk_recognitions_subscriber_id"
  add_foreign_key "recognitions", "users", name: "fk_recognitions_user_id"
  add_foreign_key "subscribers", "events", name: "fk_subscribers_event_id"
  add_foreign_key "temp_face_images", "temp_recognitions", name: "fk_temp_face_images_temp_recognition_id"
  add_foreign_key "temp_face_images_temp_recognitions", "temp_face_images", name: "fk_temp_face_images_temp_recognitions_temp_face_image_id"
  add_foreign_key "temp_face_images_temp_recognitions", "temp_recognitions", name: "fk_temp_face_images_temp_recognitions_temp_recognition_id"
  add_foreign_key "temp_recognition_photos", "temp_recognitions", name: "fk_temp_recognition_photos_temp_recognition_id"
  add_foreign_key "temp_recognitions", "subscribers", name: "fk_temp_recognitions_subscriber_id"
  add_foreign_key "upload_logs", "events"
  add_foreign_key "watermarks", "photographers"
end
