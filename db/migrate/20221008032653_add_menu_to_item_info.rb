class AddMenuToItemInfo < ActiveRecord::Migration[7.0]
  def change
    add_reference :item_infos, :menu, foreign_key: true
  end
end
