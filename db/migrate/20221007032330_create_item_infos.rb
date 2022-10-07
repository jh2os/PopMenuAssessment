class CreateItemInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :item_infos do |t|
      t.references :menu_item, null: false, foreign_key: true
      t.float :price
      t.string :portion
      t.string :calories

      t.timestamps
    end
  end
end
