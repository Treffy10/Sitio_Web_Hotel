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

ActiveRecord::Schema[7.1].define(version: 2024_03_14_022026) do
  create_table "admins", primary_key: "admin_id", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "lastnamePaternal"
    t.string "lastnameMaternal"
    t.string "dni"
    t.string "phone"
    t.string "location"
    t.date "birthday"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bedrooms", primary_key: "bedroom_id", force: :cascade do |t|
    t.integer "category_bedroom_id", null: false
    t.string "numberBedroom"
    t.integer "availability", null: false
    t.integer "floorLocation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_bedrooms", primary_key: "category_bedroom_id", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.decimal "priceNight", precision: 5
    t.integer "maxPersons"
    t.string "beds"
    t.text "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_prices", primary_key: "category_price_id", force: :cascade do |t|
    t.integer "category_bedroom_id"
    t.integer "ocupacion"
    t.float "price"
    t.float "descuento_web"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pays", primary_key: "pay_id", force: :cascade do |t|
    t.string "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "receptionists", primary_key: "recepcionist_id", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "lastnamePaternal"
    t.string "lastnameMaternal"
    t.date "birthday"
    t.string "dni"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", primary_key: "reservation_id", force: :cascade do |t|
    t.integer "user_id"
    t.integer "resident_id", null: false
    t.integer "bedroom_id"
    t.integer "pay_id"
    t.decimal "full_payment"
    t.date "arrivalDate"
    t.date "departureDate"
    t.integer "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "residents", primary_key: "resident_id", force: :cascade do |t|
    t.string "name"
    t.string "lastnamePaternal"
    t.string "lastnameMaternal"
    t.string "dni"
    t.string "phone"
    t.string "location"
    t.date "birthday"
    t.string "nationality"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", primary_key: "user_id", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admins", "users", primary_key: "user_id"
  add_foreign_key "bedrooms", "category_bedrooms", primary_key: "category_bedroom_id"
  add_foreign_key "category_prices", "category_bedrooms", primary_key: "category_bedroom_id"
  add_foreign_key "receptionists", "users", primary_key: "user_id"
  add_foreign_key "reservations", "bedrooms", primary_key: "bedroom_id"
  add_foreign_key "reservations", "pays", primary_key: "pay_id"
  add_foreign_key "reservations", "residents", primary_key: "resident_id"
  add_foreign_key "reservations", "users", primary_key: "user_id"
end
