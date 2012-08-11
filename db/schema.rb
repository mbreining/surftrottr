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

ActiveRecord::Schema.define(:version => 20091031200756) do

  create_table "bdrb_job_queues", :force => true do |t|
    t.binary   "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id",               :null => false
    t.integer  "surfspot_id"
    t.integer  "report_id"
    t.integer  "thirdparty_account_id"
    t.string   "type"
    t.integer  "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "surf_session_id"
    t.integer  "friend_id"
    t.integer  "comment_id"
    t.integer  "gear_id"
    t.integer  "surfboard_id"
    t.integer  "post_id"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "surfspot_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gears", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "category",    :null => false
    t.string   "name",        :null => false
    t.string   "brand"
    t.text     "description", :null => false
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "surf_session_id"
    t.integer  "gear_id"
    t.integer  "surfboard_id"
    t.integer  "post_id"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "title"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "embed_link"
  end

  create_table "reports", :force => true do |t|
    t.string   "type"
    t.integer  "surfspot_id",                                           :null => false
    t.integer  "user_id",                                               :null => false
    t.text     "text"
    t.datetime "actual_created_at"
    t.string   "surf_conditions"
    t.boolean  "advanced_only"
    t.string   "wave_height"
    t.string   "wind_direction"
    t.string   "wind_speed"
    t.string   "paddle_out"
    t.string   "crowd_factor"
    t.integer  "thirdparty_account_id"
    t.integer  "src_id",                :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source",                             :default => "Web"
    t.integer  "score",                              :default => 0
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "suggested_surfspots", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "tag"
    t.text     "comments"
    t.boolean  "processed",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surf_sessions", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.integer  "surfspot_id"
    t.integer  "rating",          :null => false
    t.string   "surf_conditions"
    t.string   "wave_height"
    t.string   "crowd_factor"
    t.text     "text"
    t.datetime "actual_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "surfboard_id"
    t.text     "embed_link"
  end

  create_table "surfboards", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "category",    :null => false
    t.string   "length",      :null => false
    t.string   "brand",       :null => false
    t.text     "description"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surfspots", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "thirdparty_accounts", :force => true do |t|
    t.integer  "user_id",                           :null => false
    t.boolean  "active",          :default => true
    t.string   "thirdparty_name"
    t.integer  "src_user_id"
    t.string   "src_screen_name"
    t.string   "src_avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_informations", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.string   "first_name", :default => ""
    t.string   "last_name",  :default => ""
    t.string   "city",       :default => ""
    t.string   "state",      :default => ""
    t.integer  "zipcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "role_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.boolean  "active",                  :default => true
    t.string   "screen_name"
    t.string   "email"
    t.string   "password"
    t.string   "authorization_token"
    t.string   "reason_for_deactivation", :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_login"
    t.boolean  "logged_in",               :default => false
    t.integer  "reputation",              :default => 0
  end

  create_table "votes", :force => true do |t|
    t.integer  "report_id",  :null => false
    t.integer  "user_id",    :null => false
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
