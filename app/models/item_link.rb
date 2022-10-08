class ItemLink < ApplicationRecord
  belongs_to :menu_item
  belongs_to :menu
end
