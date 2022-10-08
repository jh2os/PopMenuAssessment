require "test_helper"

class MenuItemTest < ActiveSupport::TestCase
  test "litmus test" do
     assert menu_items(:pizza).name == "Pizza"
   end

   test "can get menu" do
     assert menu_items(:pizza).menu.name == "two"
   end

   test "can get price options" do
     assert menu_items(:pizza).item_infos[0].portion == "Small"
     assert menu_items(:pizza).item_infos[1].portion == "Medium"
   end

   test "when destroyed, destroys associate ItemInfo records" do
     id = item_infos(:pizzasmall).id
     assert item_infos(:pizzasmall).menu_item.id == menu_items(:pizza).id
     assert menu_items(:pizza).destroy
     # this is excessive
     assert_raises ActiveRecord::RecordNotFound do
        ItemInfo.find(id)
     end
   end

   test "can get list of ItemInfo records dependent on condition of menu" do
     assert menu_items(:pizza).item_infos.where(:menu_id => menus(:two).id).first.portion == "Small"
   end
end
