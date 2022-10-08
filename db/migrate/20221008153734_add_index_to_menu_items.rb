class AddIndexToMenuItems < ActiveRecord::Migration[7.0]
  def change
    add_index :menu_items, :name, unique: true
  end
end
