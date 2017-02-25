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

ActiveRecord::Schema.define(version: 20170225073529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "tablefunc"
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer "user_id",                                 null: false
    t.integer "sports_id",                               null: false
    t.integer "activity",                                null: false
    t.string  "description"
    t.date    "date"
    t.time    "time"
    t.time    "duration"
    t.float   "distance",                 default: 0.0
    t.string  "effort"
    t.float   "speed",                    default: 0.0
    t.float   "pace",                     default: 0.0
    t.integer "average_power",            default: 0
    t.integer "weighted_average_power"
    t.integer "normalized_power"
    t.integer "average_heart_rate"
    t.integer "training_stress_score"
    t.integer "elevation_loss"
    t.integer "elevation_gain"
    t.float   "temp_feels_like"
    t.float   "hydration"
    t.float   "weight_before"
    t.float   "weight_after"
    t.string  "notes"
    t.integer "food"
    t.integer "urination_actual_time"
    t.integer "urination"
    t.string  "bowel_sizing"
    t.integer "bowel_movement"
    t.integer "humidity"
    t.integer "wind"
    t.string  "clouds"
    t.integer "temp"
    t.float   "sweat_rate"
    t.float   "imperial_temp_feels_like"
    t.float   "imperial_sweat_rate"
    t.boolean "is_include",               default: true
  end

  create_table "impactivities", force: :cascade do |t|
    t.integer "user_id",                                 null: false
    t.integer "sports_id",                               null: false
    t.integer "activity",                                null: false
    t.string  "description"
    t.date    "date"
    t.time    "time"
    t.time    "duration"
    t.float   "distance",                 default: 0.0
    t.string  "effort"
    t.float   "speed",                    default: 0.0
    t.float   "pace",                     default: 0.0
    t.integer "average_power",            default: 0
    t.integer "weighted_average_power"
    t.integer "normalized_power"
    t.integer "average_heart_rate"
    t.integer "training_stress_score"
    t.integer "elevation_loss"
    t.integer "elevation_gain"
    t.float   "temp_feels_like"
    t.float   "hydration"
    t.float   "weight_before"
    t.float   "weight_after"
    t.string  "notes"
    t.integer "food"
    t.integer "urination_actual_time"
    t.integer "urination"
    t.string  "bowel_sizing"
    t.integer "bowel_movement"
    t.integer "humidity"
    t.integer "wind"
    t.string  "clouds"
    t.integer "temp"
    t.float   "sweat_rate"
    t.float   "imperial_temp_feels_like"
    t.float   "imperial_sweat_rate"
    t.boolean "is_include",               default: true
  end

  create_table "sports", force: :cascade do |t|
    t.string "name"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.string "distance"
    t.string "power"
    t.string "average_heart_rate"
    t.string "pace"
    t.string "speed"
    t.string "elevation_gain"
    t.string "elevation_loss"
    t.string "weight"
    t.string "temp"
    t.string "humidity"
    t.string "wind"
    t.string "temp_feels_like"
    t.string "hydration"
    t.string "food"
    t.string "urination_actual_time"
    t.string "urination"
    t.string "bowel_movement"
    t.string "sweat_rate"
    t.string "swimming_pace"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,      null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "widget_config",          default: [2, 3],              array: true
    t.integer  "unit_type",              default: 1
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

end
