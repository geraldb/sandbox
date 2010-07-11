# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "categories", :force => true do |t|
    t.string "name"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "venue"
    t.string   "address"
    t.date     "occurs_on"
    t.time     "start_time"
    t.string   "web"
    t.text     "desc"
    t.string   "permalink"
    t.boolean  "published",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gcategories", :force => true do |t|
    t.string "name"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "permalink"
    t.boolean  "published",    :default => false
    t.boolean  "featured",     :default => false
    t.integer  "gcategory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "company"
    t.string   "web"
    t.string   "title"
    t.text     "desc"
    t.string   "contact"
    t.boolean  "full_time"
    t.boolean  "part_time"
    t.boolean  "contract"
    t.string   "permalink"
    t.boolean  "published",   :default => false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scategories", :force => true do |t|
    t.string "name"
  end

  create_table "services", :force => true do |t|
    t.integer  "group_id"
    t.integer  "scategory_id"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end
