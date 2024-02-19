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

ActiveRecord::Schema[7.1].define(version: 2024_02_19_170151) do
  create_table "admins", force: :cascade do |t|
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

  create_table "bedrooms", force: :cascade do |t|
    t.string "numberBedroom"
    t.boolean "avaibility"
    t.integer "floorLocation"
    t.integer "categoryBedroom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_bedrooms", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.float "priceNight"
    t.integer "maxPersons"
    t.string "beds"
    t.text "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pays", force: :cascade do |t|
    t.integer "reservationID"
    t.string "paymentMethod"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "receptionists", force: :cascade do |t|
    t.string "name"
    t.string "lastnamePaternal"
    t.string "lastnameMaternal"
    t.date "birthday"
    t.string "dni"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "residentID"
    t.integer "bedroomID"
    t.integer "adminID"
    t.date "dateReservation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "residents", force: :cascade do |t|
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

  create_table "users", force: :cascade do |t|
    t.integer "receptionistID"
    t.integer "adminID"
    t.string "username"
    t.string "password"
    t.date "creationDate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
