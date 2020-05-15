# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_15_070256) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", id: :serial, force: :cascade do |t|
    t.string "text"
    t.integer "home_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["home_id"], name: "index_comments_on_home_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "homes", id: :serial, force: :cascade do |t|
    t.string "agent_url"
    t.string "zoopla_url"
    t.string "rightmove_url"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "address_street"
    t.float "latitude"
    t.float "longitude"
    t.string "postcode"
    t.string "address_locality"
    t.string "address_region"
    t.text "description"
    t.boolean "disabled", default: false
    t.bigint "hunt_id"
    t.bigint "creator_user_id"
    t.index ["creator_user_id"], name: "index_homes_on_creator_user_id"
    t.index ["hunt_id"], name: "index_homes_on_hunt_id"
  end

  create_table "hunt_memberships", force: :cascade do |t|
    t.bigint "hunt_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, default: -> { "now()" }
    t.datetime "updated_at", precision: 6, default: -> { "now()" }
    t.index ["hunt_id"], name: "index_hunt_memberships_on_hunt_id"
    t.index ["user_id"], name: "index_hunt_memberships_on_user_id"
  end

  create_table "hunts", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "creator_user_id", null: false
    t.datetime "created_at", precision: 6, default: -> { "now()" }
    t.datetime "updated_at", precision: 6, default: -> { "now()" }
    t.index ["creator_user_id"], name: "index_hunts_on_creator_user_id"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "url"
    t.integer "home_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["home_id"], name: "index_images_on_home_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "homes", "hunts"
  add_foreign_key "homes", "users", column: "creator_user_id"
  add_foreign_key "hunt_memberships", "hunts"
  add_foreign_key "hunt_memberships", "users"
  add_foreign_key "hunts", "users", column: "creator_user_id"
  add_foreign_key "images", "homes"
end
