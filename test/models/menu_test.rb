require "test_helper"

class MenuTest < ActiveSupport::TestCase
   test "litmus test" do
     assert menus(:one).name == "one"
   end

   test "can get child menu" do
     assert menus(:one).sub_menus[0].name == "two"
   end

   test "can get parent menu" do
     assert menus(:two).parent_menu.name == "one"
   end

   test "can get menu items" do
     assert menus(:two).menu_items.count == 2
   end

   test "when destroyed, destroys child menus" do
     assert menus(:one).destroy
     assert_raises ActiveRecord::RecordNotFound do
        menus(:two)
     end
     assert_raises ActiveRecord::RecordNotFound do
        menus(:three)
     end
   end

   test "when destroyed, nullifies child MenuItems" do
     assert menu_items(:pizza).menu.id == menus(:two).id
     assert menus(:two).destroy
     # this feels excessive
     assert MenuItem.find(menu_items(:pizza).id).menu == nil
   end
end