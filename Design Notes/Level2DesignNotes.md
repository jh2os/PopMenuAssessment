# Level 1 design notes:
___
## Requirements Note:
Thinking about the implementations, these directions are a little confusing.
* If a menu item can be on multiple menus of a Restaurant:
  * It implies different pricing between the items exist (like the difference between a lunch, dinner, happy hour, ect...).
    * This could be handled with 2 many-to-many implementations. (Menu <-> MenuItem) and ~~(Menu <-> ItemInfo)~~ Menu has many ItemInfo.
    * So when an item is added to a menu, you could select which pricing option to display on that menu.


* If MenuItem's names can't be duplicated in the database & "MenuItem can be on multiple Menu s of a Restaurant .":
  * "a Restaurant" signifies to me that "pizza" for restaurant 1 is different than "pizza" for restaurant 2
    * this could be handled via a has_many relation  Restaurant has_many:MenuItem.
      * However this limits the ability to have the same item being used on multiple restaurants (which isn't listed as a requirement because "a Restaurant" but feels like it would be an important option for a menu manager to have. It reduces the amount of work for the person managing it where they do not have to recreate the item for each restaurant/location")
    * but with MenuItem's name being unique this means that in managing the menuItems it is probably necessary to have two different name fields.
      * Name: a unique name for the MenuItem that signifies which restaurant e.g. "Bob's Pizza" "Larry's Pizza" bobs_pizza Larrys_pizza
      * DisplayName: a non-unique name that is displayed on the consumer side menu e.g. "Pizza"
  * _I think without knowing the rest of the requirements it would save time and extra engineering if I simply added a unique index on the MenuItem name. If the requirement of menu items being different for different restaurants comes up, the previous solutions could be implemented with just adding a string column_

So the best solution seems to be adding a field to MenuItem for a display name, and making the name field unique.

~~If menu items need to be managed in the backend dependent on the restaurant, a many to many relation can be made(as to not rely on strings for queries), but for the time being, I will wait to see the next step of the assessment to implement this if necessary.~~ A many to many relationship is necessary.

## Next steps:
MenuItems currently only links to one Menu object.

MenuItems and Menu will need to have a many-to-many relationship. I think the Has Many Through method would provide the most straight forward approach, seeing as it gives us direct access to the related objects

Menu would also need to have a relation to ItemInfo to set the price options for individual menus (regular vs happy hour etc.)

ItemInfo will belong to one menu. In an environment when an end user would be able to edit the menu item, they could set all the prices for the different menus it belongs to in a single place.

So a new model is required to hold the references because MenuItem can now belong to multiple menus MenuItem <-> Menu many to many through relationship

`rails generate model ItemLink menu_item:references menu:references`

ItemInfo needs a column to reference the menu it belongs to.

`rails g migration AddMenuToItemInfo menu:references`

Then Restaurant model (which for now I will leave basic as there are no requirements for restaurants other than containing menus). It will has_many: menus

`rails generate model Restaurant name:string`

Menus will need to have a parent restaurant.
`#db call for adding restaurant_id to menu model`
`rails g migration AddRestToItemInfo menu:references`

MenuItem will need to be unique in the database and validate


  `rails generate migration add_index_to_menu_items name:uniq`


**notes:**
ItemOption will only belong to one Menu. This means that in managing the menu, if a price changes they will need to change every instance of it. However if a list is displayed of all the different pricing options with the associated restaurant and menus it could be done from a single place in the UI. This reduces the design by not having to add one more relational model.
Also the abstraction between MenuItem and ItemOption leads to some oddities in calling for information to display, it's not terribly efficient but provides the easiest solution for displaying.

    page : /billysresuarant

    restaurant = Restaurant.find(name="billysresuarant")   
    topmenu = restaurant.menus.find(:parent_menu_id => nil)

    topsmenu.each do | m |
      display m.name
      display m.description

      #display items
      m.menu_items.each do | item |
        display item.name
        display item.description

        #display price options
        m.item_infos.find(:menu => m.id).each do | option |
          display option.portion
          display option.price
        end
      end
    end


Menu needs to relate to restaurant

    class Restaurant
      has_many :menus
    end

    class Menu
      belongs_to  :restaurant
      has_many    :sub_menus, class_name: 'Menu', foreign_key: "parent_menu_id", dependent: :destroy
      belongs_to  :parent_menu, class_name: 'Menu', optional: true
      validates   :name, presence: true
      has_many    :item_links
      has_many    :menu_items, through :menu_links
      has_many    :item_infos
    end

    class item_links
      belongs_to :menu_item
      belongs_to :menu
    end

    class MenuItem
      has_many :item_links
      has_many :menus, through: :item_links
      validates :name, presence: true

    end

    class item_info
      belongs_to :menu_item
      belongs_to :menu optional: true
    end
