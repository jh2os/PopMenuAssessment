# PopMenuAssessment app/models/menu.rb

class Menu < ApplicationRecord
  # model Menu name:string description:text parent_menu:references
  # Menu is a self-referential model. This allows menu nesting
  has_many :sub_menus, class_name: 'Menu', foreign_key: "parent_menu_id", dependent: :destroy
  belongs_to :parent_menu, class_name: 'Menu', optional: true

  validates :name, presence: true

end
