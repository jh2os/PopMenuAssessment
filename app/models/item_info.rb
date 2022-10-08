class ItemInfo < ApplicationRecord
  belongs_to :menu_item
  belongs_to :menu, optional: true
end
