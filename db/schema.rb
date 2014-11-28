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

ActiveRecord::Schema.define(version: 20141127165607) do

  create_table "access_tokens", force: true do |t|
    t.string   "key"
    t.datetime "expires_at"
    t.integer  "user_id"
  end

  add_index "access_tokens", ["key"], name: "index_access_tokens_on_key"

  create_table "budgets", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "session_id"
  end

  create_table "localizations", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "price_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "localizations", ["price_id"], name: "index_localizations_on_price_id"

  create_table "payments", force: true do |t|
    t.integer  "value"
    t.integer  "budget_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["budget_id"], name: "index_payments_on_budget_id"

  create_table "prices", force: true do |t|
    t.integer  "value"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["product_id"], name: "index_prices_on_product_id"

  create_table "products", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "purchase_id"
    t.string   "bar_code"
  end

  create_table "purchases", force: true do |t|
    t.integer  "price"
    t.integer  "shopping_id"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "purchases", ["shopping_id"], name: "index_purchases_on_shopping_id"

  create_table "sessions", force: true do |t|
    t.integer "user_id"
    t.string  "secret"
  end

  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id"

  create_table "shoppings", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "budget_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shoppings", ["budget_id"], name: "index_shoppings_on_budget_id"

  create_table "users", force: true do |t|
    t.string "email",           null: false
    t.string "password_digest"
  end

end
