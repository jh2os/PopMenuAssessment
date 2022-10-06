require 'rails_helper'

RSpec.describe Menu, type: :model do
  # Basic data layout for a menu ===============================================

  let(:mainmenu) { Menu.create(:name => "Main Menu") }
  let(:category1) { Menu.create(:name => "submenu1", :parent_menu => mainmenu) }
  let(:subcategory1) { Menu.create(:name => "submenu1-1", :parent_menu => category1) }
  let(:subcategory2) { Menu.create(:name => "submenu1-2", :parent_menu => category1) }
  let(:category2) { Menu.create(:name => "submenu2", :parent_menu => mainmenu) }
  let(:subcategory3) { Menu.create(:name => "submenu2-1", :parent_menu => category2) }
  let(:subcategory4) { Menu.create(:name => "submenu2-2", :parent_menu => category2) }
  let(:testmain) {Menu.find(mainmenu.id)}
  let(:menus) {[mainmenu, category1, subcategory1, subcategory2, category2, subcategory3, subcategory4]}

  # this function is imperitive for tests to reload the association for child relations
  def checkValid(modelarray)
    modelarray.all?{|x| x.valid?}
  end

  # Check if record can be made and is saved to the database====================
  describe "can not create record" do
    it "without name" do
      expect(Menu.create.valid?).to eql(false)
    end
# NOTE: Is this test necessary? type mismatch in active record always returns error...
#    it "without a valid Menu object" do
#      expect(Menu.create(:name => "menuname", :parent_menu => 1).errors).to eql(false)
#    end
  end
  describe "should be able to create record:" do
    # Check if our records exist in database with different creation options
    it "without a parent Menu" do
      expect(mainmenu.valid?).to eql(true)
      expect(Menu.find(mainmenu.id).name).to eql("Main Menu")
    end
    it "with a parent menu" do
      expect(category1.valid?).to eql(true)
      expect(Menu.find(category1.id).name).to eql("submenu1")
    end
    it "not all records valid" do

    end
  end

  # Check parent-child relation/access =========================================
  describe "linking should" do
    it "return nil if no parent exits" do
      expect(Menu.find(mainmenu.id).parent_menu).to eql(nil)
    end
    it "return parent object" do
      expect(Menu.find(category1.id).parent_menu).to eql(mainmenu)
      expect(Menu.find(subcategory3.id).parent_menu).to eql(category2)
    end

    it "return list of children" do
      # Have to run these to properly or have to access variables to load for test
      #expect(mainmenu.valid? && category1.valid? && category2.valid? ).to eql(true)
      expect(checkValid(menus)).to eql(true)
      expect(mainmenu.sub_menus.to_ary).to eql([category1, category2])
      expect(category1.sub_menus.to_ary).to eql([subcategory1, subcategory2])
      expect(subcategory1.sub_menus.to_ary).to eql([])
    end
  end

  describe "updating should" do
    it "change name" do
      expect(mainmenu.update(name: "The Menu")).to eql(true)
      expect(Menu.find(mainmenu.id).name).to eql("The Menu")
    end
  end
end
