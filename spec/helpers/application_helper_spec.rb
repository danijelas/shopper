require "spec_helper"

describe ApplicationHelper, type: :helper do
  
  describe "#title" do
     it "should return the supplied block if a block was given" do
      helper.title("Some Block")
      expect(helper.content_for?(:title)).to be_truthy
    end
  end

  describe 'currency_codes' do
    it 'should return array of currency codes' do
      expect(helper.currency_codes).not_to be_empty
    end
  end

end