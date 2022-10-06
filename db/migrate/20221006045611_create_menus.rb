class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.string :name
      t.text :description
      t.references :parent_menu, foreign_key: {to_table: :menus}

      t.timestamps
    end
  end
end
