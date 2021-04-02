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

ActiveRecord::Schema.define(version: 2021_04_02_182141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "card_id", null: false
    t.string "card_type", null: false
    t.string "name", null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active"], name: "index_cards_on_active"
    t.index ["card_type", "card_id"], name: "card_type_index"
    t.index ["name"], name: "index_cards_on_name"
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active"], name: "index_categories_on_active"
    t.index ["name"], name: "index_categories_on_name"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "credits", force: :cascade do |t|
    t.decimal "limit", null: false
    t.decimal "super_limit"
    t.integer "due_day", null: false
    t.integer "closing_day", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "debits", force: :cascade do |t|
    t.decimal "current_money", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "expense_recurrents", force: :cascade do |t|
    t.bigint "expense_id"
    t.date "date", null: false
    t.decimal "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expense_id"], name: "index_expense_recurrents_on_expense_id"
  end

  create_table "expense_tags", force: :cascade do |t|
    t.bigint "expense_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expense_id"], name: "index_expense_tags_on_expense_id"
    t.index ["tag_id"], name: "index_expense_tags_on_tag_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "card_id"
    t.bigint "group_id"
    t.bigint "category_id"
    t.string "description", null: false
    t.string "expense_type", null: false
    t.date "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_expenses_on_card_id"
    t.index ["category_id"], name: "index_expenses_on_category_id"
    t.index ["description"], name: "index_expenses_on_description"
    t.index ["group_id"], name: "index_expenses_on_group_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active"], name: "index_groups_on_active"
    t.index ["name"], name: "index_groups_on_name"
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "income_recurrents", force: :cascade do |t|
    t.bigint "income_id"
    t.date "date", null: false
    t.decimal "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["income_id"], name: "index_income_recurrents_on_income_id"
  end

  create_table "income_tags", force: :cascade do |t|
    t.bigint "income_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["income_id"], name: "index_income_tags_on_income_id"
    t.index ["tag_id"], name: "index_income_tags_on_tag_id"
  end

  create_table "incomes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "card_id"
    t.bigint "group_id"
    t.bigint "category_id"
    t.string "description", null: false
    t.string "income_type", null: false
    t.date "end_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_incomes_on_card_id"
    t.index ["category_id"], name: "index_incomes_on_category_id"
    t.index ["description"], name: "index_incomes_on_description"
    t.index ["group_id"], name: "index_incomes_on_group_id"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "monthly_expenses", force: :cascade do |t|
    t.string "expense_type"
    t.string "description"
    t.decimal "value"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "monthly_incomes", force: :cascade do |t|
    t.string "income_type"
    t.string "description"
    t.decimal "value"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["active"], name: "index_tags_on_active"
    t.index ["name"], name: "index_tags_on_name"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name", null: false
    t.string "email", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

  add_foreign_key "cards", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "expense_recurrents", "expenses"
  add_foreign_key "expense_tags", "expenses"
  add_foreign_key "expense_tags", "tags"
  add_foreign_key "expenses", "cards"
  add_foreign_key "expenses", "categories"
  add_foreign_key "expenses", "groups"
  add_foreign_key "expenses", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "income_recurrents", "incomes"
  add_foreign_key "income_tags", "incomes"
  add_foreign_key "income_tags", "tags"
  add_foreign_key "incomes", "cards"
  add_foreign_key "incomes", "categories"
  add_foreign_key "incomes", "groups"
  add_foreign_key "incomes", "users"
  add_foreign_key "tags", "users"
end
