# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091022190806) do

  create_table "prov_sessions", :force => true do |t|
    t.integer  "prov_user_id"
    t.string   "ip"
    t.string   "path"
    t.string   "session_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prov_users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prov_xns", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "employeenumber"
    t.string   "familyname"
    t.string   "givenname"
    t.string   "suspended"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "userclass"
    t.string   "mailhost"
    t.string   "iplanetdn"
    t.string   "adadmindn"
  end

end
