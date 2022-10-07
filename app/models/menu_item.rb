class MenuItem < ApplicationRecord
  has_many :item_infos, dependent: :destroy

  belongs_to :menu, optional: true
  validates :name, presence: true
end
