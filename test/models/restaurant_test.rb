require "test_helper"

class RestaurantTest < ActiveSupport::TestCase
  test "has menus" do
    assert restaurants(:billysrestuarant).menus.count > 0
  end
end
