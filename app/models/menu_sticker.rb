# PopMenuAssessment app/models/menu.rb

class MenuSticker < ApplicationRecord
# model MenuSticker name:string icon:string category:string

validates :name, presence: true
validates :icon, presence: true
validates :category, presence: true
end
