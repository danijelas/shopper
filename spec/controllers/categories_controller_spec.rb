require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }

  before(:each) do
    login_user(user)
  end

  describe "GET index" do
    it "return all categories that belongs to current user" do
      second_user = create(:user)
      category1 = create(:category, user: user)
      category2 = create(:category, user: second_user)
      category3 = create(:category, user: second_user)
      
      get :index, user_id: user
      
      expect(response).to be_success
      expect(response).to render_template("index")
      
      expect(assigns(:categories)).to match_array([user.categories[0], user.categories[1], 
        user.categories[2], user.categories[3], user.categories[4], 
        user.categories[5], category1])
      expect(assigns(:categories)).not_to match_array([user.categories[0], user.categories[1], 
        user.categories[2], user.categories[3], user.categories[4], 
        user.categories[5], category1, category2, category3])
    end
  end

  describe "GET new" do
    it "assigns a new category as @category" do
      
      xhr :get, :new, user_id: user
      
      expect(response).to be_success
      expect(response).to render_template("new")
      
      expect(assigns(:category)).to be_a_new(Category)
    end
  end

  describe "GET edit" do
    it "edits category" do
      category = user.categories[0]
      
      xhr :get, :edit, id: category, user_id: user
      
      expect(response).to be_success
      expect(response).to render_template("edit")
      
      expect(assigns(:category)).to eq(category)
      expect(assigns(:category).user).to eq(user)
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "creates a new Category" do
        c = FactoryGirl.attributes_for(:category)
        expect do
          xhr :post, :create, category: c, user_id: user
        end.to change(Category, :count).by(1)
        
        expect(response).to be_success
        expect(response).to render_template("create")
        
        expect(assigns(:category)).to be_a(Category)
        expect(assigns(:category)).to be_persisted
        expect(assigns(:category).user).to eq(user)
      end
    end

    context "with invalid params" do
      it "does not save the new category" do
        expect do
          xhr :post, :create, category: { name: nil }, user_id: user
        end.to_not change(Category,:count)
        
        expect(response).to render_template("categories/create_error")
        
        expect(assigns(:category)).to be_a_new(Category)
        expect(assigns(:category)).to_not be_persisted
        expect(assigns(:category).user).to eq(user)
      end
    end
  end

  describe "PUT update" do

    let(:category) {user.categories[0]}    

    context "with valid params" do
      it "updates the requested category" do
        put :update, id: category, category: {name: 'updatedCategory'}, user_id: user, format: :js
        category.reload
        expect(category.name).to eq('updatedCategory')
      end
    end

    context "with invalid params" do
      it "does not update the requested category" do
        categoryName = category.name
        xhr :put, :update, id: category, category: {name: nil}, user_id: user
        category.reload

        expect(response).to render_template("categories/update_error")
        expect(category.name).to eq(categoryName)
      end 
    end
  end

  describe "DELETE destroy" do

    it "destroys the requested category" do
      category = user.categories[0]
      expect do
        xhr :delete, :destroy, id: category, user_id: user
      end.to change(Category, :count).by(-1)
      expect(response).to be_success
      expect(assigns(:category).user).to eq(user)
    end
  end
end
