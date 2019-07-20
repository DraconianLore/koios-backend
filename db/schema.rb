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

ActiveRecord::Schema.define(version: 2019_07_20_213710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cyphers", force: :cascade do |t|
    t.string "title"
    t.text "desctiption"
    t.text "message"
    t.text "solution"
    t.boolean "encrypt"
    t.string "encryptionType", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mission_types", force: :cascade do |t|
    t.integer "type_id"
    t.boolean "photo"
    t.boolean "verification"
    t.boolean "encryption"
    t.boolean "decryption"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "missions", force: :cascade do |t|
    t.string "status"
    t.integer "experience"
    t.string "missionType"
    t.datetime "startTime"
    t.datetime "endTime"
    t.string "difficuilty"
    t.integer "verificationUsers", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "photoType", array: true
    t.binary "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "surname"
    t.string "firstName"
    t.string "email"
    t.string "password"
    t.integer "currentMission"
    t.integer "completedMissions", default: [], array: true
    t.integer "experience"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "verifications", force: :cascade do |t|
    t.binary "image"
    t.string "title"
    t.string "description"
    t.integer "verifications"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
