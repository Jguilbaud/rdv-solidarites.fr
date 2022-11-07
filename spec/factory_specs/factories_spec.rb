# frozen_string_literal: true

# This file is not in spec/factory to avoid running this test everytime we run another spec
FactoryBot.factories.each do |factory|
  describe "The #{factory.name} factory" do
    it "is valid" do
      expect(build(factory.name)).to be_valid
    end
  end
end
