require "spec_helper"
describe ApplicationHelper, type: :helper do
  describe "#title" do
     it "should return the supplied block if a block was given" do
      helper.title("Some Block")
      expect(helper.content_for?(:title)).to be_truthy
    end
  end
end