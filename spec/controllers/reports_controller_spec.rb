require 'rails_helper'

RSpec.describe ReportsController, type: :controller do

  let(:user) { create(:user, currency: 'EUR') }

  before(:each) do
    login_user(user)
  end

  describe "GET index" do
    it "returns hash map with category name and price sum of all items for that category, that belongs to current user" do
      list1 = create(:list, user: user, currency: 'EUR')
      list2 = create(:list, user: user, currency: 'EUR')
      list3 = create(:list, user: user, currency: 'USD')
      category1 = user.categories[0]
      category2 = user.categories[1]
      category3 = create(:category, user: user)
      item1 = create(:item, category: category1, price: 2.00, list: list1, done: true)
      item2 = create(:item, category: category2, price: 3.00, list: list1, done: true)
      item3 = create(:item, category: category3, price: 4.00, list: list1, done: true)
      item4 = create(:item, category: category1, price: 2.00, list: list1, done: true)
      item5 = create(:item, category: category2, price: 3.00, list: list1, done: true)
      item6 = create(:item, category: category3, price: 4.00, list: list1, done: true)
      item7 = create(:item, category: category1, price: 2.00, list: list2, done: true)
      item8 = create(:item, category: category2, price: 3.00, list: list2, done: true)
      item9 = create(:item, category: category3, price: 4.00, list: list2, done: true)
      item10 = create(:item, category: category1, price: 2.00, list: list2, done: true)
      item11 = create(:item, category: category2, price: 3.00, list: list2, done: true)
      item12 = create(:item, category: category3, price: 4.00, list: list2, done: true)
      item13 = create(:item, category: category1, price: 10.00, list: list3, done: true)
      item13_price = item13.price_user_currency
      catsHash = Hash.new
      catsHash['Dairy'] = 8.00 + item13_price
      catsHash[category3.name] = 16.00
      catsHash['Bakery'] = 12.00
      get :index
      expect(response).to be_success
      expect(response).to render_template("index")
      expect(assigns(:cats_name_sum)).to eq(catsHash)
    end
  end

  describe "GET chart_data" do
    it "returns hash map with category name and price sum of all items for specific period for that category, that belongs to current user" do
      list1 = create(:list, user: user, currency: 'EUR')
      list2 = create(:list, user: user, currency: 'EUR')
      list3 = create(:list, user: user, currency: 'USD')
      category1 = user.categories[0]
      category2 = user.categories[1]
      category3 = create(:category, user: user)
      item1 = create(:item, category: category1, price: 2.00, list: list1, done: true)
      item1.update_attribute(:updated_at, Time.now - 20.day)
      item2 = create(:item, category: category2, price: 3.00, list: list1, done: true)
      item2.update_attribute(:updated_at, Time.now - 20.day)
      item3 = create(:item, category: category3, price: 4.00, list: list1, done: true)
      item3.update_attribute(:updated_at, Time.now - 20.day)
      item4 = create(:item, category: category1, price: 2.00, list: list1, done: true)
      item4.update_attribute(:updated_at, Time.now - 10.day)
      item5 = create(:item, category: category2, price: 3.00, list: list1, done: true)
      item5.update_attribute(:updated_at, Time.now - 10.day)
      item6 = create(:item, category: category3, price: 4.00, list: list1, done: true)
      item6.update_attribute(:updated_at, Time.now - 10.day)
      item7 = create(:item, category: category1, price: 2.00, list: list2, done: true)
      item7.update_attribute(:updated_at, Time.now - 20.day)
      item8 = create(:item, category: category2, price: 3.00, list: list2, done: true)
      item8.update_attribute(:updated_at, Time.now - 20.day)
      item9 = create(:item, category: category3, price: 4.00, list: list2, done: true)
      item9.update_attribute(:updated_at, Time.now - 20.day)
      item10 = create(:item, category: category1, price: 2.00, list: list2, done: true)
      item10.update_attribute(:updated_at, Time.now - 10.day)
      item11 = create(:item, category: category2, price: 3.00, list: list2, done: true)
      item11.update_attribute(:updated_at, Time.now - 10.day)
      item12 = create(:item, category: category3, price: 4.00, list: list2, done: true)
      item12.update_attribute(:updated_at, Time.now - 10.day)
      item13 = create(:item, category: category1, price: 10.00, list: list3, done: true)
      item13.update_attribute(:updated_at, Time.now - 10.day)
      item14 = create(:item, category: category1, price: 10.00, list: list3, done: true)
      item14.update_attribute(:updated_at, Time.now - 20.day)
      # last 30 days
      item13_price = item13.price_user_currency
      item14_price = item14.price_user_currency
      catsHash = Hash.new
      catsHash['Dairy'] = 8.0 + item13_price + item14_price
      catsHash[category3.name] = 16.0
      catsHash['Bakery'] = 12.0
      get :chart_data, days: 30, format: :js
      expect(response).to be_succes
      expect(assigns(:cats_name_sum)).to eq(catsHash)
      # last 15 days
      catsHash15 = Hash.new
      catsHash15['Dairy'] = 4.0 + item13_price
      catsHash15[category3.name] = 8.0
      catsHash15['Bakery'] = 6.0
      get :chart_data, days: 15, format: :js
      expect(response).to be_success
      expect(assigns(:cats_name_sum)).to eq(catsHash15)
      jsonCatsHash15 = catsHash15.to_json
      expect(response.body).to eq(jsonCatsHash15)
    end
  end

end
