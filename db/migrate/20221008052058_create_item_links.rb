class CreateItemLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :item_links do |t|
      t.references :menu_item, null: false, foreign_key: true
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
