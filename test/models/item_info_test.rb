require "test_helper"

class ItemInfoTest < ActiveSupport::TestCase

  test "litmus test" do
    assert item_infos(:pizzasmall).portion == "Small"
    assert item_infos(:pizzasmall).price == 1.23
  end

  test "Can get menu item" do
    assert item_infos(:pizzasmall).menu_item.name == "Pizza"
  end
end
