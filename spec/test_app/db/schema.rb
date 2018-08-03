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

ActiveRecord::Schema.define(version: 2017_10_02_213441) do

  create_table "bics", force: :cascade do |t|
    t.string "country", null: false
    t.string "bank_code", null: false
    t.string "bic", null: false
    t.index ["country", "bank_code"], name: "index_bics_on_country_and_bank_code", unique: true
  end

end
