# PopMenuAssessment spec/models/menu_spec.rb

require 'rails_helper'

RSpec.describe Menu, type: :model do
  # Basic data layout for a menu ===============================================

  let(:mainmenu) { Menu.create(:name => "Main Menu") }
  let(:category1) { Menu.create(:name => "submenu1", :parent_menu => mainmenu) }
  let(:subcategory1) { Menu.create(:name => "submenu1-1", :parent_menu => category1) }
  let(:subcategory2) { Menu.create(:name => "submenu1-2", :parent_menu => category1) }
  let(:category2) { Menu.create(:name => "submenu2", :parent_menu => mainmenu) }
  let(:subcategory3) { Menu.create(:name => "submenu2-1", :parent_menu => category2) }
  let(:subsubcat) { Menu.create(:name => "lowest menu", :parent_menu => subcategory3) }
  let(:subcategory4) { Menu.create(:name => "submenu2-2", :parent_menu => category2) }
  let(:testmain) {Menu.find(mainmenu.id)}
  let(:menus) {[mainmenu, category1, subcategory1, subcategory2, category2, subcategory3, subsubcat, subcategory4]}

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
      expect(subcategory1.sub_menus.to_ary).to be_empty
    end
  end

  describe "updating. It should" do
    it "change name" do
      expect(mainmenu.update(name: "The Menu")).to eql(true)
      expect(Menu.find(mainmenu.id).name).to eql("The Menu")
    end

    it "change parent" do
      expect(Menu.find(category2.id).update(name: "Special Sub-menu", parent_menu: category1)).to eql(true)
      expect(checkValid(menus)).to eql(true)
      expect(category1.sub_menus.to_ary).to eql([category2,subcategory1, subcategory2])
    end
  end

  describe "destroying should" do
    it "remove lowest menu" do
      catid = subcategory1.id
      expect(subcategory1.destroy.valid?).to eql(true)
      expect {Menu.find(catid)}.to raise_error(ActiveRecord::RecordNotFound)

    end

    it "delete immediate children" do
      expect(checkValid(menus)).to eql(true)
      catid = category1.id
      subc1 = subcategory1.id
      subc2 = subcategory1.id
      subc3 = subcategory3.id

      expect(category1.destroy.valid?).to eql(true)
      expect(Menu.exists?(catid)).to eql(false)
      expect(Menu.exists?(subc1)).to eql(false)
      expect(Menu.exists?(subc2)).to eql(false)
      expect(Menu.find(subc3)).to eql(subcategory3)
    end

    it "delete all lower children (3 teirs)" do
      expect(checkValid(menus)).to eql(true)
      checkDeleted = [category2.id, subcategory3.id, subsubcat.id, subcategory4.id]
      checkStillExists = [mainmenu.id, category1.id,  subcategory1.id]

      expect(category2.destroy.valid?).to eql(true)

      checkDeleted.each do |record|
        expect(Menu.exists?(record)).to eql(false)
      end
      checkStillExists.each do |record|
        expect(Menu.exists?(record)).to eql(true)
      end
    end

    it "delete everything if it's a root menu" do
      # reset our menus and build an array of their id's
      expect(checkValid(menus)).to eql(true)
      testrecords = menus.map {|record| record.id}

      # delete the main menu
      expect(mainmenu.destroy.valid?).to eql(true)

      # check to make sure all the records have been destroyed
      testrecords.each do |record|
        expect(Menu.exists?(record)).to eql(false)
      end
    end
  end
end
