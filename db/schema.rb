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

ActiveRecord::Schema[7.0].define(version: 2022_10_08_052058) do
  create_table "item_infos", force: :cascade do |t|
    t.integer "menu_item_id", null: false
    t.float "price"
    t.string "portion"
    t.string "calories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "menu_id"
    t.index ["menu_id"], name: "index_item_infos_on_menu_id"
    t.index ["menu_item_id"], name: "index_item_infos_on_menu_item_id"
  end

  create_table "item_links", force: :cascade do |t|
    t.integer "menu_item_id", null: false
    t.integer "menu_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_item_links_on_menu_id"
    t.index ["menu_item_id"], name: "index_item_links_on_menu_item_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "images"
    t.text "menuStickers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_stickers", force: :cascade do |t|
    t.text "name"
    t.string "icon"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "parent_menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id", null: false
    t.index ["parent_menu_id"], name: "index_menus_on_parent_menu_id"
    t.index ["restaurant_id"], name: "index_menus_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "item_infos", "menu_items"
  add_foreign_key "item_infos", "menus"
  add_foreign_key "item_links", "menu_items"
  add_foreign_key "item_links", "menus"
  add_foreign_key "menus", "menus", column: "parent_menu_id"
  add_foreign_key "menus", "restaurants"
end
