class MenuItem < ApplicationRecord
  has_many :item_infos, dependent: :destroy

  # Menu links
  has_many :item_links, dependent: :destroy
  has_many :menus, through: :item_links

  validates :name, presence: true, uniqueness: true
end
