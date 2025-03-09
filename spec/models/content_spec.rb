require 'rails_helper'

RSpec.describe Content, type: :model do
  describe "Validations" do
    let(:valid_image) { fixture_file_upload(Rails.root.join("spec/fixtures/sample.png"), "image/png") }

    it "is valid with a media file and description" do
      content = Content.new(description: "Valid description")
      content.media.attach(valid_image)
      expect(content).to be_valid
    end

    it "is invalid without a description" do
      content = Content.new(description: "")
      expect(content).to_not be_valid
      expect(content.errors[:description]).to include("must be at least 10 characters")
    end

    it "is invalid if description is too short" do
      content = Content.new(description: "Short")
      expect(content).to_not be_valid
      expect(content.errors[:description]).to include("must be at least 10 characters")
    end

    it "is invalid if description exceeds 100 characters" do
      long_description = "a" * 101  # 101 characters
      content = Content.new(description: long_description)
      expect(content).to_not be_valid
      expect(content.errors[:description]).to include("must not exceed 100 characters")
    end

    it "is valid if description is exactly 100 characters" do
      valid_description = "a" * 100  # Exactly 100 characters
      content = Content.new(description: valid_description)
      content.media.attach(valid_image)
      expect(content).to be_valid
    end
  end
end
