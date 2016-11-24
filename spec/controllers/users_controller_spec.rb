require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  let(:user) { create(:user) }

  before(:each) do
    login_user(user)
  end
  
  # describe "GET index" do
    
  #   it "should have a current_user" do
  #     expect(subject.current_user).not_to be_nil
  #   end

  #   it "renders users index" do
  #     get :index
  #     expect(response).to be_success
  #     expect(response).to render_template(:index)
  #   end

  # end

  # describe "GET show/:id" do
    
  #   it "should have a current_user" do
  #     expect(subject.current_user).not_to be_nil
  #   end

  #   it "renders user show" do
  #     get :show, id: user.id
  #     expect(response).to be_success
  #     expect(response).to render_template(:show)
  #   end

  # end

  describe "POST set_currency" do
    it "sets currency" do
      
      post :set_currency, currency: 'RSD', format: :js
      
      expect(session[:currency]).to eq('RSD')
    end
  end

end