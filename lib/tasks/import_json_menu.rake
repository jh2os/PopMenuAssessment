namespace :popimport do

  class PopImport
    attr_reader :importstats
    attr_reader :errors
    def initialize(parsedjsondata)
      @originaldata = parsedjsondata
      @restaurants = Array.new
      @menus = Array.new
      @menuItems = Array.new
      @menuOptions = Array.new
      @menuLinks = Array.new
      @errors = Array.new
      @menuItemNameHash = Hash.new
      importRestaurants parsedjsondata
    end

    def savedata
      @restaurants.each do |restaurant|
        begin
          puts "Saving restaurant: \t#{restaurant.name}"
          restaurant.save
        rescue => e
          puts "Error in saving #{restaurant.name}: #{e}"
          return
        end
      end
      @menus.each do | menu |
        begin
          puts "Saving menu: \t#{menu.restaurant.name} | #{menu.name}"
          menu.save
        rescue => e
          puts "Error in saveing #{menu.restaurant.name}:#{menu.name}: #{e}"
          return
        end
      end
      @menuItems.each do | item |
        begin
          puts "Saving item: \t#{item.name}"
          item.save
        rescue => e
          puts "Error in saving #{item.name}: #{e}"
        end
      end
      @menuLinks.each do | link |
        begin
          puts "Linking: \t#{link.menu.restaurant.name}:#{link.menu.name} - #{link.menu_item.name}"
          link.save
        rescue => e
          puts "Error in saving #{link.name}: #{e}"
        end
      end
      @menuOptions.each do | option |
        begin
          puts "Saving price: \t$#{option.price} \t#{option.menu.restaurant.name}:#{option.menu.name} - #{option.menu_item.name}"
          option.save
        rescue => e
          puts "Error in saving option: #{e}"
        end
      end

    end


    def counts
      {:restaurants => @restaurants.count,:menus => @menus.count,:menuItems  => @menuItems.count, :menuOptions => @menuOptions.count, :item_links => @menuLinks.count}
    end

    private
    # Checks if which key is in hash. returns the first key that is found, nil otherwise
    def getValidKey checkhash, values
        values.each { |v| return v if checkhash.has_key?(v) }
        return nil
    end

    # Start the import loops from the restaurant level
    def importRestaurants data
      if restaurantSelector = getValidKey(data, ["restaurants"])
        puts "\nFound data:"
        puts "-----------"
        data[restaurantSelector].each do |restaurant|
          newrestaurant = Restaurant.new(:name => restaurant["name"])
          @restaurants << newrestaurant
          puts "[restaurant] #{newrestaurant.name}"
          importMenus restaurant, newrestaurant
          puts "-----------"
        end
      else
        puts "No restaurants found!"
      end
    end

    def importMenus  restaurant_data, restaurant_object, menu_parent = nil
      if menuSelector = getValidKey(restaurant_data, ["menus"])
        restaurant_data[menuSelector].each do |menu|
          newmenu = Menu.new(
            :name => menu["name"],
            :description => "",
            :parent_menu => menu_parent,
            :restaurant => restaurant_object
          )
          @menus << newmenu
          puts "\t[menu] #{newmenu.name}"

          importItems menu, newmenu
        end
      end
    end

    def importItems menu_data, menu_object
      if itemselect = getValidKey(menu_data, ["menu_items", "dishes"])
        thisMenuItemsList = Array.new
        menu_data[itemselect].uniq.each do |item|
          if @menuItemNameHash.has_key?(item["name"])
            existingitem = @menuItemNameHash[ (item["name"]) ]
            puts "\t\t[item] #{item["name"]}***"
            linkItemAndMenu(menu_object, existingitem)
            itemprice = importOption(menu_object, existingitem, item["price"])
            puts "\t\t\t[price] #{itemprice.price}"
          else
            newitem = MenuItem.new(
              :name => item["name"],
              :description => "",
              :images => "",
              :menuStickers => "",
            )
            @menuItems << newitem
            @menuItemNameHash[newitem.name] = newitem
            puts "\t\t[item] #{newitem.name}"
            menulink = linkItemAndMenu(menu_object, newitem)
            itemprice = importOption(menu_object, newitem, item["price"])
            puts "\t\t\t[price] #{itemprice.price}"
          end
        end
        if menu_data[itemselect].uniq.length != menu_data[itemselect].length
          # There are duplicate menu items in this list
          puts "\t\tNOTE: Duplicates have been automatically removed"
        end
        puts "\n"
      end
    end

    def linkItemAndMenu(menu, item)
      newlink = ItemLink.new(:menu => menu, :menu_item => item)
      if newlink.valid?
        @menuLinks << newlink
        return newlink
      else
        return nil
      end
    end

    def importOption(menu, menu_item, price)
      newOption = ItemInfo.new(:menu_item => menu_item, :menu => menu, :price => price.to_f)
      if newOption.valid?
        @menuOptions << newOption
        return newOption
      else
        return nil
      end
    end
  end



  def confirm
    input = nil
    while(input = STDIN.gets.chomp)
      if input.downcase == "y" or input.downcase == 'yes'
        return true
      elsif input.downcase == "n" or input.downcase == 'no'
        return false
      else
        puts "Invalid input, confirm? (y/n)"
      end
    end
  end

  desc "Import example JSON menu data"
  task :loadfile => :environment do
    file = "import_data/restaurant_data.json"
    begin
      importData = JSON.parse(File.read(file))
      puts "\n\nImporting Restaurant Data\n\n"
      puts "File loaded: #{file},\n importing will completely wipe the database of all menu and restaurant information. Are you sure you want to continue? (y/n)"
      if confirm
        begin
          Restaurant.destroy_all
          MenuItem.destroy_all
          ItemInfo.destroy_all
          ItemLink.destroy_all
        rescue => e
          puts "Error when removing existing records: #{e}"
          return
        end
        import = PopImport.new(importData)
        puts "*** Menu Item alread exists, its data will be the same as the existing menu item"
        puts "\n\n\nDoes this data look correct (y/n)?: "

        if confirm

          puts "\nAlright we'll process and save the data..."
          import.savedata

          puts "Successfully updated the applicatoin with new data"
        else
          puts "Exiting..."
        end

      else
        puts "Exiting..."
      end
    rescue => e
      puts "Error encountered when loading file: #{e}"
    end
  end
end
