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

ActiveRecord::Schema.define(version: 2020_06_04_141917) do

  create_table "periods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "starts_on", null: false
    t.date "ends_on", null: false
    t.boolean "is_closed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
  end

  create_table "punches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.column "punch_type", "enum('start_work','end_work','start_break','end_break','notes','remote_start','remote_end')"
    t.datetime "punch_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.bigint "period_id", null: false
    t.bigint "edited_by_id"
    t.bigint "reason_code_id"
    t.text "notes"
    t.datetime "edited_at"
    t.float "temperature"
    t.index ["deleted_at"], name: "index_punches_on_deleted_at"
    t.index ["edited_by_id"], name: "index_punches_on_edited_by_id"
    t.index ["period_id"], name: "index_punches_on_period_id"
    t.index ["reason_code_id"], name: "index_punches_on_reason_code_id"
    t.index ["user_id"], name: "index_punches_on_user_id"
  end

  create_table "reason_codes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code", null: false
    t.boolean "requires_notes", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "employee_number", null: false
    t.string "name", null: false
    t.string "pin", limit: 4, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.column "status", "enum('clocked_in','clocked_out','on_break','remote_in')"
    t.datetime "status_timestamp"
    t.datetime "secondary_status_timestamp"
    t.datetime "deleted_at"
    t.integer "access_level", default: 1, null: false
    t.string "username"
    t.boolean "remote_allowed", default: false, null: false
    t.boolean "foreman_allowed", default: false, null: false
    t.boolean "is_foreman", default: false, null: false
    t.integer "foreman_priority", default: 0, null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.text "object_changes", size: :long
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "punches", "periods"
  add_foreign_key "punches", "reason_codes"
  add_foreign_key "punches", "users"
  add_foreign_key "punches", "users", column: "edited_by_id"
end
