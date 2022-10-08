# PopMenuAssessment spec/models/menu_sticker_spec.rb

require 'rails_helper'

RSpec.describe MenuSticker, type: :model do
  describe "saves new record without required values." do
    describe "Record created without:" do
      it "any parameters" do
        sticker = MenuSticker.new()
        expect(sticker.save).to eql(false) # Does this work?
      end
      it "a name" do
        sticker = MenuSticker.new(icon: "🌾", category: "flare")
        expect(sticker.save).to eql(false)
      end
      it "an icon" do
        sticker = MenuSticker.new(name: "Gluten Free", category: "flare")
        expect(sticker.save).to eql(false)
      end
      it "a category" do
        sticker = MenuSticker.new(name: "Gluten Free", icon: "🌾")
        expect(sticker.save).to eql(false)
      end
    end
  end

  describe "failed to" do
    sticker = MenuSticker.create(name: "Gluten Free", icon: "🌾", category: "flare")

    it "save record & find ID" do
      expect(MenuSticker.find(sticker.id).name).to eql("Gluten Free")
    end

    ## NOTE: the ID can be updated and probably shouldn't be  ##
    ## but I don't currently know how to protect a built in   ##
    ## data object or if I should. If so is standard to test? ##                            ##
    describe "update record:" do
      describe "blank values: " do
          it "name" do
            expect(MenuSticker.find(sticker.id).update(name: "")).to eql(false)
          end

          it "icon" do
            expect(MenuSticker.find(sticker.id).update(icon: "")).to eql(false)
          end

          it "category" do
            expect(MenuSticker.find(sticker.id).update(category: "")).to eql(false)
          end
      end
      describe "failed to update" do
        it "name" do
          expect(MenuSticker.find(sticker.id).update(name: "test")).to eql(true)
        end
        it "icon" do
          expect(MenuSticker.find(sticker.id).update(icon: "*")).to eql(true)
        end
        it "category" do
          expect(MenuSticker.find(sticker.id).update(category: "*")).to eql(true)
        end
      end
      ## Note: should there be a test for inserting non-existing data? ##
    end

    it "delete record" do
      expect(MenuSticker.find(sticker.id).destroy.destroyed?).to eql(true)
    end
  end
end
