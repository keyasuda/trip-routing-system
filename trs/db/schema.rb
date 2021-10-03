# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_03_131519) do

  create_table "days", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "start_waypoint_id"
    t.integer "end_waypoint_id"
    t.datetime "start_at", precision: 6
    t.integer "trip_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["trip_id"], name: "index_days_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "waypoints", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.float "longitude"
    t.float "latitude"
    t.integer "stop_min"
    t.integer "index"
    t.integer "day_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day_id"], name: "index_waypoints_on_day_id"
  end

  add_foreign_key "days", "trips"
  add_foreign_key "waypoints", "days"
end
