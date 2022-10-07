require 'rails_helper'

RSpec.describe ItemInfo, type: :model do
  describe "can create" do
    it "an empty record" do
      expect(ItemInfo.create.valid?).to eql(false)
    end
  end
  describe "can't create" do
    it "an option with a parent" do
      expect(ItemInfo.create(:menu_item_id => 1).valid?).to eql(true)
    end
    it "with just a price no parent" do
      expect(ItemInfo.create(:price => 1).valid?).to eql(false)
    end
    it "with all info provided" do
      expect(ItemInfo.create(:menu_item_id => 1, :price => 1, :portion => "small", :calories => "100").valid?).to eql(true)
      expect(ItemInfo.create(:menu_item_id => 1, :price => 1.1, :portion => "small", :calories => "100").valid?).to eql(true)
      expect(ItemInfo.create(:menu_item_id => 1, :price => "1.1", :portion => "small", :calories => "100").valid?).to eql(true)
    end
  end
  describe "updating" do
    item = ItemInfo.create(:menu_item_id => 1);
    it "failed" do
      expect(item.update(:price => 200.23, :portion => "huge", :calories => "9000+")).to eql(true)
      expect(ItemInfo.find(item.id).price).to eql(200.23)
    end
  end

end
