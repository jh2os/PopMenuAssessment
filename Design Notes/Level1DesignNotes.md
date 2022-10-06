# Level 1 design notes:
___
## Basic Menu outline:
> Pizza:
>
>> Peperoni Pizza 🔥
>>
>> Some classic pizza
>> * 1 slice  $2  100cal
>> * 2 slices $3  200cal
>> * Whole Pie $10 800cal
>>
>
> Pasta:
>
>> Mom's Spaghet†
>>
>> A plate of spaghetii | $6 | 400 cal

> Drinks:
>> Beer:
>>> IPA:
>>>> Beer 1 $5
>>>>
>>>> Beer 2 $5
>>>
>>> Stout:
>>>> Beer 3 $6
>>>
>>> Soft Drinks:
>>>> Coca-Cola Products
>>>>
>>>> $3 Regular $2 Kids

🔥 Customer favorite

† Eating raw meat might be bad...

___
## Level 1 Object ideation
#### MenuItem: (model):

>    MenuItem is to hold all information regarding a food item. Name, description, an image (or multiples?), portion sizes and prices, calorie information, special identifiers (hot seller, GF, Vegan, etc...), and footnotes (meat warning, egg warning, etc..).

Basic Data Types:
* Name (text)
* Description (textarea)
* Image (text link)

Complex Types:
* Images (array)
  * ImageFileName (text)
* ~~Portions (array) * Price (number) * Portion size (text) * Calories for this portion (text) ~~
* MenuStickers (object hash): collection of MenuStickers that apply to item

Links:
  * item_info (has_many) ItemInfo children (price, portion, calories)
  * Menu belongs_to optional parent
>**Note: A Flare and Notes class will have to be created.**
>
>**Update: on second thought menu flare and menu notes can be in the same model and you could just flag them as note/flare/etc... This also allows for adding additional data types**
>
>
>#### ~~~MenuFlare: (model):~~~
>
>~~Menu Flare are icons or flags that can be applied to MenuItems such as Gluten Free, Vegan, >Specials, Favorites ect...~~
>
>#### ~~~MenuNotes: (class)~~~
>~~Menu notes will contain all the footnotes that are printed at the bottom of menus.~~

#### MenuSticker: (model)

> A catchall data class for applying image/key stickers and notes to a menu item like Vegan, Gluten Free, Hot Seller, and food warning notes. See note and update above ^

Basic Data:
* Footnote text (text)
* Footnote symbol/image (text) (e.g. † ‡ *, 🌾, "images/icon.svg" )
* category name (text) - keeping this just text allows for extension in the future


#### Menu: (model)
> Menu possibly contains reference to a list of other menus (category). If there are no more categories then it would contain selected menu items (MenuItem). It can also contain description information

Basic Data:
* Menu Description
* Parent

Links:
* Submenus (menu) - the submenus below the current menu
* Menu Items (menu_item) - Items that show up at this menu level


__*There could be a level of abstraction between the idea of the "Menu" and the categories/sub-menus. It would offer the ability to manage MenuFlare and MenuNotes at the top level of a menu. In thinking about possible front-end implementations of managing a menu, I believe the abstraction can be largely resolved through a separate menu interface and by possibly adding them from the menuItem level. By keeping the notes and flare menu agnostic it would allow for global implementations across different menus like a drink or desert menu. So the top menu is actually just another instance of a sub-menu with no parent.*__

#### ItemInfo: (model)
  * Price (float)
  * Portion (string)
  * Calories (string)

links:
  * Menu Item (menu_item) parent


## Class specifications

#### class MenuSticker
* name
  * about: This text is necessary for generating key for icons and food warnings
  * type: text
  * required: yes
* icon
  * about: These could be emojis, daggers, image file names ect...
  * type: string
  * required: yes
* category
  * about: keeping this as text seems like the best option. Through the front end you could make it a quick select option based on unique values, or break them up into different ui elements when managing the list of these. Different menus would have different demands. Without knowing the exact specifications, I am building this in as generic of a way possible.
  * type: string
  * required: yes - this may be overkill for some menus but seems like the best option.

`rails generate model MenuSticker name:string icon:string category:string`

    validates :name, presence: true
    validates :icon, presence: true
    validates :category, presence: true


#### class ItemInfo
  * menuItem
    * about: Reference to MenuItem ID
    * type: references
    * required: yes
  * price
    * about: Price information for selected menu item's portion. If there is only one portion then there only needs to be one ItemInfo assigned to the MenuItem
    * type: float
    * required: yes
  * portion
    * about: Just some text describing what portion is associated with the price. No validation required because portion sizes can be small, medium, half slab, jumbo, 2 dogs, etc...
    * type: string
    * required: no
  * calories
    * about: a number of places offer calorie information, so better to just include it
    * type: string
    * required: no

`rails generate model ItemInfo menu_item:references price:float portion:string calories:string`

#### class MenuItem
* name
  * about: This is the name of the food item as it appears on the menu
  * type: string
  * required: yes
* description
  * about: This is the description that will show for each menu item
  * type: text
  * required: no - Some menu items do not need any extra description
* ~~~details~~~
  * ~~about: A serialized set of information about the product price, portions, calories. If worked into a cart system the cart would take on the menu item id and option array index for price. It keeps price data server-side to protect against client-side modification~~ note: these will be a child relation to menuItem

  * type: text
  * required: Yes. --There should be some extra validation to ensure there is at least one price
* images
  * about: serialized list of image files. (this could be extended out to have ruby handle images as objects so they could have multiple sizes and insert cdn security, etc... This would mean it would be a serialized list of image object id's)
  * type: text
  * required: No
* menuStickers
  * about: serialized list of sticker objects to display on menu item.
  * type: text
  * required: No

`rails generate model MenuItem name:string description:text details:text images:text menuStickers:text`

    validates :name, presence: true
    validates :details, presence: true

#### class Menu

`rails generate model MenuSticker name:string icon:string category:string`

`rails generate model Menu name:string description:text parent_menu:references`

`rails generate model MenuItem name:string description:text images:text menuStickers:text menu:references`

`rails generate model ItemInfo menu_item:references price:float portion:string calories:string`
