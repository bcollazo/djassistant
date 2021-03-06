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

ActiveRecord::Schema.define(version: 20151012040422) do

  create_table "songs", force: :cascade do |t|
    t.string   "name"
    t.string   "artists"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "songs_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "song_id"
  end

  add_index "songs_users", ["song_id"], name: "index_songs_users_on_song_id"
  add_index "songs_users", ["user_id"], name: "index_songs_users_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "display_name"
    t.string   "spotify_id"
    t.string   "email"
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "last_spotify_sync_date"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
