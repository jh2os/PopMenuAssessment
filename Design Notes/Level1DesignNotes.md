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
#### MenuItem: (class):

>    MenuItem is to hold all information regarding a food item. Name, description, an image (or multiples?), portion sizes and prices, calorie information, special identifiers (hot seller, GF, Vegan, etc...), and footnotes (meat warning, egg warning, etc..).

Basic Data Types:
* Name (text)
* Description (textarea)
* Image (text link)

Complex Types:
* Images (array)
  * ImageFileName (text)


* Portions (array)
  * Price (number)
  * Portion size (text)
  * Calories for this portion (text)


* Flare (string):  ?A comma separated list of references to flare objects?
* Notes (string): ?A comma separated list of references to Notes?

**Note: A Flare and Notes class will have to be created.**

#### MenuFlare: (class):
> Menu Flare are icons or flags that can be applied to MenuItems such as Gluten Free, Vegan, Specials, Favorites ect... They should contain a unique identifier, A text description, and optional icon/image

Basic Data:
* Description (text)
* Image (image file name or emoji for this exercise)


#### MenuNotes: (class)
>Menu notes will contain all the footnotes that are printed at the bottom of menus.

Basic Data:
* Footnote text (text)
* Footnote character (text) (e.g. † ‡ *)


#### Menu: (class)
> Menu possibly contains reference to a list of other menus (category). If there are no more categories then it would contain selected menu items (MenuItem). It can also contain description information

Basic Data:
* Menu Description
* Parent

Complex Types:
* Sub-menus (array) [Menu]
* Menu Items (array) [MenuItem]


__*There could be a level of abstraction between the idea of the "Menu" and the categories/sub-menus. It would offer the ability to manage MenuFlare and MenuNotes at the top level of a menu. In thinking about possible front-end implementations of managing a menu, I believe the abstraction can be largely resolved through a separate menu interface and by possibly adding them from the menuItem level. By keeping the notes and flare menu agnostic it would allow for global implementations across different menus like a drink or desert menu. So the top menu is actually just another instance of a sub-menu with no parent.*__


## Class specifications

#### class MenuFlare

#### class MenuNotes

#### class MenuItem

#### class Menu
