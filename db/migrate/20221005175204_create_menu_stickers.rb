class CreateMenuStickers < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_stickers do |t|
      t.text :name
      t.string :icon
      t.string :category

      t.timestamps
    end
  end
end
