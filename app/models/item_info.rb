class ItemInfo < ApplicationRecord
  belongs_to :menu_item
  belongs_to :menu, optional: true
  validates :price, uniqueness: {scope: [:menu, :menu_item], message: "Price option already exists for this product on this menu"}
end
