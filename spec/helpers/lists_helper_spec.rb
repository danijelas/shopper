require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ListsHelper. For example:
#
# describe ListsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ListsHelper, type: :helper do
  
  describe 'total_sum' do
    it 'returns sum for one list in users currency' do

      allow_any_instance_of(Money).to receive(:exchange_to).and_return('9.00')

      user = create(:user, currency: 'EUR')
      list1 = create(:list, user: user, currency: 'USD')
      create(:item, list: list1, price: 4, done: true)
      create(:item, list: list1, price: 6, done: true)
      expect(helper.total_items_sum(user, list1)).to eq('10.00 USD/9.00 EUR')

      list2 = create(:list, user: user, currency: 'EUR')
      create(:item, list: list2, price: 4, done: true)
      create(:item, list: list2, price: 6, done: true)
      expect(helper.total_items_sum(user, list2)).to eq('10.00 EUR')

      list3 = create(:list, user: user, currency: 'USD')
      item1 = create(:item, list: list3, price: 4, done: true)
      item2 = create(:item, list: list3, price: 6, done: true)
      items1 = []
      items1 << item1
      items1 << item2
      expect(helper.total_items_sum(user, list3, items1)).to eq('10.00 USD/9.00 EUR')

      list4 = create(:list, user: user)
      item3 = create(:item, list: list4, price: 4, done: true)
      item4 = create(:item, list: list4, price: 6, done: true)
      items2 = []
      items2 << item3
      items2 << item4
      expect(helper.total_items_sum(user, list4, items2)).to eq('10.00 EUR')
    end
  end

end
