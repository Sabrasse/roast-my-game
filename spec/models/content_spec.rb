require 'rails_helper'

RSpec.describe Content, type: :model do
  describe "Validations" do
    it "is valid with a media file and description" do
      content = Content.new(description: "Valid description")
      content.media.attach(io: File.open("spec/fixtures/sample.png"), filename: "sample.png", content_type: "image/png")
      expect(content).to be_valid
    end

    it "is invalid without a description" do
      content = Content.new(description: "")
      expect(content).to_not be_valid
    end

    it "is invalid if description is too short" do
      content = Content.new(description: "Short")
      expect(content).to_not be_valid
    end
  end
end
