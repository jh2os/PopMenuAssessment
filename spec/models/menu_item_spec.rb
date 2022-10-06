require 'rails_helper'

RSpec.describe MenuItem, type: :model do

  let(:pizza) { MenuItem.create(:name => "Pizza") }

  describe "can create" do
    it "an empty record" do
      expect(MenuItem.create.valid?).to eql(false)
    end
  end

  describe "can't create" do
    it "a menu item with just a name" do
      expect(MenuItem.create(:name => "Pizza").valid?).to eql(true)
    end

    it "a menu item with just a name" do
      expect(MenuItem.create(:name => "Pizza").valid?).to eql(true)
    end
  end

  describe "fails to update" do
    it "record" do
      expect(
        pizza.update(
          :name => "BigPizza",
          :description => "This is a really big pizza",
          :images => "bigpizza.jpg",
          :menuStickers => "001,002")
      ).to eql(true)
    end
  end
end
