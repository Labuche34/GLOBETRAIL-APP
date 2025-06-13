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

ActiveRecord::Schema[7.1].define(version: 2025_06_13_090309) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.bigint "stop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stop_id"], name: "index_notes_on_stop_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "description"
    t.bigint "stop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stop_id"], name: "index_pictures_on_stop_id"
  end

  create_table "spendings", force: :cascade do |t|
    t.string "category"
    t.decimal "amount"
    t.string "currency"
    t.bigint "stop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stop_id"], name: "index_spendings_on_stop_id"
  end

  create_table "stops", force: :cascade do |t|
    t.string "notes"
    t.string "city"
    t.bigint "travel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["travel_id"], name: "index_stops_on_travel_id"
  end

  create_table "travels", force: :cascade do |t|
    t.string "country"
    t.integer "number_of_travellers"
    t.float "budget"
    t.integer "trip_duration"
    t.string "departure_city"
    t.string "travellers_type"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "departure_date"
    t.date "return_date"
    t.index ["user_id"], name: "index_travels_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "notes", "stops"
  add_foreign_key "pictures", "stops"
  add_foreign_key "spendings", "stops"
  add_foreign_key "stops", "travels"
  add_foreign_key "travels", "users"
end
