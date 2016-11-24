require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:user) { create(:user) }

  before(:each) do
    login_user(user)
  end

  describe "GET new" do
    it "assigns a new item as @item" do
      list = create(:list, user: user)
      
      xhr :get, :new, list_id: list
      
      expect(response).to be_success
      expect(response).to render_template("new")
      
      expect(assigns(:item)).to be_a_new(Item)
    end
  end

  describe "GET edit" do
    it "edits item" do
      list = create(:list, user: user)
      item1 = create(:item, list: list)
      item2 = create(:item, list: list)
      
      xhr :get, :edit, list_id: list, id: item1
      
      expect(response).to be_success
      expect(response).to render_template("edit")
      
      expect(assigns(:item)).to eq(item1)
      expect(assigns(:item).list).to eq(list)
    end
  end

  describe "POST create" do
    
    let(:list) {create (:list), user: user, currency: 'EUR'}
    
    context "with valid params" do
      it "creates a new Item" do
        i = FactoryGirl.attributes_for(:item, done: true)
        session[:currency] = 'RSD'

        expect do
          xhr :post, :create, item: i, list_id: list
        end.to change(Item, :count).by(1)
        
        expect(response).to be_success
        expect(response).to render_template("create")
        
        expect(assigns(:item)).to be_a(Item)
        expect(assigns(:item)).to be_persisted
        expect(assigns(:item).list).to eq(list)

        expect(assigns(:item).list.currency).to eq(session[:currency])
        expect(assigns(:disable_currency_select)).to eq(true)
      end
    end

    context "with invalid params" do
      it "does not save the new item" do
        expect do
          xhr :post, :create, item: { name: nil }, list_id: list
        end.to_not change(Item,:count)
        
        expect(response).to render_template("items/create_error")
        
        expect(assigns(:item)).to be_a_new(Item)
        expect(assigns(:item)).to_not be_persisted
        expect(assigns(:item).list).to eq(list)
      end
    end
  end

  describe "PUT update" do

    let(:list) {create (:list), user: user, currency: 'EUR'}
    let(:item) {create (:item), list: list, done: true}    

    context "with valid params" do
      it "updates the requested item" do
        session[:currency] = 'RSD'
        category1 = user.categories[0]
        put :update, id: item, item: {name: 'updatedItemName', 
          category_id: category1.id, description: 'updatedDescription', 
          price: 10}, list_id: list, format: :js
        item.reload
        list.reload
        expect(item.name).to eq('updatedItemName')
        expect(item.category_id).to eq(category1.id)
        expect(item.description).to eq('updatedDescription')
        expect(item.price).to eq(10)
        expect(assigns(:item).list.currency).to eq(session[:currency])
      end
    end

    context "with invalid params" do
      it "does not update the requested item" do
        itemName = item.name
        xhr :put, :update, id:item, item: {name: nil}, list_id: list
        item.reload

        expect(response).to render_template("items/update_error")
        expect(item.name).to eq(itemName)
      end 
    end
  end

  describe "DELETE destroy" do

    let!(:list) {create (:list), user: user}
    let!(:item) {create (:item), list: list}

    it "destroys the requested list" do
      expect do
        xhr :delete, :destroy, id: item, list_id: list
      end.to change(Item, :count).by(-1)
      expect(response).to be_success
      expect(assigns(:item).list).to eq(list)
    end
  end

  describe "GET show_confirm_done" do
    it "renders confirm_done template" do
      list = create(:list, user: user)
      item1 = create(:item, list: list)
      item2 = create(:item, list: list)
      
      xhr :get, :show_confirm_done, list_id: list, id: item1
      
      expect(response).to be_success
      expect(response).to render_template("show_confirm_done")
      
      expect(assigns(:item)).to eq(item1)
      expect(assigns(:item).list).to eq(list)
    end
  end

  describe "POST save_done" do

    let(:list) {create (:list), user: user, currency: 'EUR'}
    let(:item) {create (:item), list: list, done: false}    

    context "with valid params" do
      it "updates the requested item, set done to true" do
        session[:currency] = 'RSD'
        category1 = user.categories[0]
        @disable_currency_select = false
        post :save_done, id: item, item: {name: 'updatedItemName', 
          category_id: category1.id, description: 'updatedDescription', 
          price: 10, done: true}, list_id: list, format: :js
        item.reload
        list.reload
        
        expect(item.name).to eq('updatedItemName')
        expect(item.category_id).to eq(category1.id)
        expect(item.description).to eq('updatedDescription')
        expect(item.price).to eq(10)
        expect(item.done).to eq(true)
        expect(assigns(:item).list.currency).to eq(session[:currency])
        expect(assigns(:disable_currency_select)).to eq(true)
      end
    end

    context "with invalid params" do
      it "does not update the requested item or set done to true" do
        itemName = item.name
        xhr :post, :save_done, id: item, item: {name: nil}, list_id: list
        item.reload

        expect(response).to render_template("items/save_done_error")
        expect(item.name).to eq(itemName)
      end 
    end
  end

  describe "POST save_done" do
    context "with valid params" do
      it "sets done to false" do
        list = create(:list, user: user)
        item = create(:item, list: list, done: true)
        @disable_currency_select = true
        post :undone, id: item, list_id: list, format: :js
        item.reload
        
        expect(item.done).to eq(false)
        expect(assigns(:disable_currency_select)).to be_nil
      end
    end

    context "with invalid params", skip: 'how to make update_atribute fail' do
      it "does not set done to false" do
      end 
    end
  end
end
